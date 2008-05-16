Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYEPRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYEPRcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYEPRcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:32:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbYEPRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:32:16 -0400
Subject: Re: [regression bisected] HR-timers bug >=2.6.25
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Justin Madru <jdm64@gawab.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <482DC3B2.3040907@gawab.com>
References: <482C8FD6.10808@gawab.com>
	 <alpine.LFD.1.10.0805160909450.3255@apollo.tec.linutronix.de>
	 <1210922458.7886.14.camel@twins>  <482DC3B2.3040907@gawab.com>
Content-Type: text/plain
Date: Fri, 16 May 2008 19:31:56 +0200
Message-Id: <1210959116.6524.26.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 10:26 -0700, Justin Madru wrote:
> Peter Zijlstra wrote:
> > The kernel doesn't hang, right? My reading of the description tells me
> > the splash just doesn't work.
> >
> > If it does hang the kernel, an NMI trace collected over serial or
> > netconsole (regular console being out of the question since its
> > graphical stuff :/) would be most helpful.
> 
> I've seen it blank out in 2 different ways.
> 
> 1) Usplash completely finishes. Then screen goes blank for the usual mode change/screen refreshing,
> doing several refreshes of a blank screen. But, the screen then stays black.
> I do still hear the gdm sound, and can switch to a console.
> Pressing ctrl+alt+f1 makes the screen "refresh" again, but stay blank/black. I can still login but blindly.
> 
> 2) More rarely. Usplash hasn't finished (but near the end). The usplash screen fades out to black.
> It's like a screen burn in, or after image; the screen slowly fades out to black.
> After this the computer is _seemingly_unresponsive_ - Only alt+sysrq+b seems to work. (I have to hard reset)
> After I reboot the backlight is at the lowest level.
> 
> Anyways, I think I can figure out how to set up a netconsole, but
> is there something more to setup a NMI trace? I found Documentation/networking/netconsole.txt
> But, it doesn't say anything about a NMI trace.

those can be obtained by adding:

  nmi_watchdog=[12]

to the kernel boot parameters - it depends a bit on the hardware which
of the two choices works best, just start with 1 and if that doesn't
work try 2.

This enabled the NMI watchdog and that will print a backtrace when it
times out after 30 or so seconds.

