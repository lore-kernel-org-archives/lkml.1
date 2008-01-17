Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYAQCMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYAQCMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYAQCMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:12:34 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:48821 "EHLO
	outbound4-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbYAQCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:12:33 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Subject: Re: [PATCH 1/4] RT: remove duplicate time/Kconfig
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <Pine.LNX.4.58.0801162027110.19540@gandalf.stny.rr.com>
References: <1200435525.4092.14.camel@bx740>
	 <20080116004051.GF30532@goodmis.org> <1200530798.3939.17.camel@bx740>
	 <Pine.LNX.4.58.0801162027110.19540@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 18:11:21 -0800
Message-Id: <1200535881.3939.23.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 02:12:26.0977 (UTC) FILETIME=[67D73510:01C858AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-16 at 20:29 -0500, Steven Rostedt wrote:
> On Wed, 16 Jan 2008, Frank Rowand wrote:
> 
> >
> > time/Kconfig added by preempt-realtime-mips.patch duplicates other entry,
> > resulting in kernel make error:
> >
> > Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> > ---
> >  arch/mips/Kconfig |    2 	0 +	2 -	0 !
> >  1 files changed, 2 deletions(-)
> >
> > Index: linux-2.6.24-rc7/arch/mips/Kconfig
> > ===================================================================
> > --- linux-2.6.24-rc7.orig/arch/mips/Kconfig
> > +++ linux-2.6.24-rc7/arch/mips/Kconfig
> > @@ -1001,8 +1001,6 @@ config BOOT_ELF64
> >
> >  menu "CPU selection"
> >
> > -source "kernel/time/Kconfig"
> > -
> >  choice
> >  	prompt "CPU type"
> >  	default CPU_R4X00
> 
> heh, This doesn't apply either. Or is this to be done before the patches
> are added?

Hmmm, I don't seem to be doing to well here.  It was created after the
-rt3 patch was applied.  Thanks for you patience with me here!!

> 
> Anyway, I did find the two konfig references:
> 
> ...
> 
>           This is purely to save memory - each supported CPU adds
>           approximately eight kilobytes to the kernel image.  For best
>           performance should round up your number of processors to the next
>           power of two.
> 
> source "kernel/time/Kconfig"
> 
> #
> # Timer Interrupt Frequency Configuration
> #
> 
> ...
> 
> config GENERIC_TIME
>         bool
>         default y
> 
> source "kernel/time/Kconfig"
> 
> config CPU_SPEED
>         int "CPU speed used for clocksource/clockevent calculations"
>         default 600
> endmenu
> 
> ...
> 
> 
> I'll apply your patch in quilt and then make the proper change. Which
> Kconfig do you want gone?

It would be good to get rid of the first one, but I'm especially picky.


> 
> -- Steve
> 
> 


