Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0CERSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:18:13 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:60601 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261Ab0CERSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:18:12 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Date: Fri, 5 Mar 2010 18:18:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, cloos@jhcloos.com
References: <20100305025435.GA6836@linux.vnet.ibm.com> <201003050443.30431.elendil@planet.nl> <20100305052014.GA6869@linux.vnet.ibm.com>
In-Reply-To: <20100305052014.GA6869@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003051818.10486.elendil@planet.nl>
X-OriginalArrivalTime: 05 Mar 2010 17:18:11.0173 (UTC) FILETIME=[D4E2F150:01CABC87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 March 2010, Paul E. McKenney wrote:
> But let's work out what the error strategy should be.  The below are my
> initial guesses, I of course must defer to those more familiar with
> kbuild and kconfig than am I.

That's not me either :-)
I see you've not CCed linux-kbuild@vger.k.o so far. Suggest you add them 
with the next version.

> 1.	Oddball SCM conditions should not cause the build to fail.
> 	"Arrrgh!!!  What dot-file do I need to remove in order for
> 	my builds to start succeeding???"

Agreed.

> 2.	Errors should leave some hint in the .config file, rather
> 	than simply mysteriously omitting the version/dirty information.

I don't see why this should be treated any different than 
CONFIG_LOCALVERSION_AUTO. Either setlocalversion returns something (on 
stdout) and you use it, or it returns nothing and you don't.

With CONFIG_LOCALVERSION_AUTO errors get ignored (tested by adding 'exit 1' 
early in the script) and output to stderr simply gets displayed (without 
any real identification where it comes from).

If users expect the SCM version info to be there and it isn't, they will 
investigate.

> 4.      Should the splat in the .config file identify the file and
>         line number?  For example: "-error: scripts/confdata.c:nnnn"

IMHO definitely not. I think you're over-designing this. It's not really 
core functionality. My viewpoint is simple: a version string should 
contain version info, and nothing else.

> After this is done, I am going to return to something easier to
> understand, like the Linux kernel's RCU implementation.  ;-)

:-)
