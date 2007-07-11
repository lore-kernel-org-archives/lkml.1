Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXGKMPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXGKMPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763752AbXGKMPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:15:18 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62833 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763437AbXGKMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:15:15 -0400
Subject: Re: Documentation of kernel messages (Summary)
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Rob Landley <rob@landley.net>
Cc: Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, arjan@infradead.org, sam@ravnborg.org,
       jengelh@computergmbh.de, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
In-Reply-To: <200707101212.38981.rob@landley.net>
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com>
	 <200707101212.38981.rob@landley.net>
Content-Type: text/plain
Organization: IBM
Date: Wed, 11 Jul 2007 14:15:16 +0200
Message-Id: <1184156116.11139.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Tue, 2007-07-10 at 12:12 -0400, Rob Landley wrote:

[snip]

> > Yeah, but it seems like having a translations directory in the kernel
> > avoids that problem - anyone can update, it is a single source, no digging
> > for sites that aren't tied to the kernel, available in the distros
> > directly, etc.
> 
> No.  It doesn't help.
> 
> 99% of the kernel directory is C.  That means any random passerby can review 
> code.  Everyone who has the kernel tarball should be able to review code 
> that's in there, plus when you compile it breaks.  So merging _code_ into the 
> kernel helps keep it up to date.
> 
> Merging documentation into the kernel doesn't help keep it up to date, because 
> documentation being out of date doesn't break the build.  It may get the 
> documentation more review, but the existing state of Documentation/* argues 
> against that.  It's a struggle to keep the english versions on the same 
> continent as "up to date" or "complete", and most of the _good_ documentation 
> is out in OLS papers and such (which I'm off indexing as we speak).

With the checker tool, which we suggested in the initial proposal, it is
possible to verify

 * that every marked message has a description
 * that there are no descriptions without corresponding messages
 * that format strings of message and description match

So when compiling the kernel using C=1, you will at least see warnings,
when a message has changed or a message disappeared:

>> make modules C=1
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHECK   drivers/kmsgtest/kmsgtest.c
drivers/kmsgtest/kmsgtest.c: Missing description for: kmsgtest.1
drivers/kmsgtest/kmsgtest.c: Description without message for: kmsgtest.3

Michael



