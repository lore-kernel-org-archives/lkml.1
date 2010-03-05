Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0CEULF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:11:05 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50741 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab0CEULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:11:01 -0500
Date: Fri, 5 Mar 2010 12:10:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, cloos@jhcloos.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305201051.GG6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100305025435.GA6836@linux.vnet.ibm.com> <201003050443.30431.elendil@planet.nl> <20100305052014.GA6869@linux.vnet.ibm.com> <201003051818.10486.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003051818.10486.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 06:18:08PM +0100, Frans Pop wrote:
> On Friday 05 March 2010, Paul E. McKenney wrote:
> > But let's work out what the error strategy should be.  The below are my
> > initial guesses, I of course must defer to those more familiar with
> > kbuild and kconfig than am I.
> 
> That's not me either :-)
> I see you've not CCed linux-kbuild@vger.k.o so far. Suggest you add them 
> with the next version.

Ah, will do on v5.

> > 1.	Oddball SCM conditions should not cause the build to fail.
> > 	"Arrrgh!!!  What dot-file do I need to remove in order for
> > 	my builds to start succeeding???"
> 
> Agreed.
> 
> > 2.	Errors should leave some hint in the .config file, rather
> > 	than simply mysteriously omitting the version/dirty information.
> 
> I don't see why this should be treated any different than 
> CONFIG_LOCALVERSION_AUTO. Either setlocalversion returns something (on 
> stdout) and you use it, or it returns nothing and you don't.
> 
> With CONFIG_LOCALVERSION_AUTO errors get ignored (tested by adding 'exit 1' 
> early in the script) and output to stderr simply gets displayed (without 
> any real identification where it comes from).
> 
> If users expect the SCM version info to be there and it isn't, they will 
> investigate.

Understood, but I am concerned about the case where one person creates
the configuration and another is looking at the .config file.

> > 4.      Should the splat in the .config file identify the file and
> >         line number?  For example: "-error: scripts/confdata.c:nnnn"
> 
> IMHO definitely not. I think you're over-designing this. It's not really 
> core functionality. My viewpoint is simple: a version string should 
> contain version info, and nothing else.

s/you're over-designing this/you are freaking paranoid/

With that change, I plead guilty to charges as read.  But again, I am
worried about the case where one person generates the .config file
and someone else is reading it.  And my paranoia has proven quite useful
over the years.  ;-)

							Thanx, Paul

> > After this is done, I am going to return to something easier to
> > understand, like the Linux kernel's RCU implementation.  ;-)
> 
> :-)
