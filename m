Return-Path: <linux-kernel-owner+w=401wt.eu-S1765240AbYBULGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765240AbYBULGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbYBULGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:06:09 -0500
Received: from nn7.de ([85.214.94.156]:54112 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942AbYBULGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:06:07 -0500
Subject: Re: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200802210131.54272.rjw@sisk.pl>
References: <1203422386.10992.2.camel@localhost>
	 <200802200050.10158.rjw@sisk.pl> <1203487269.6542.1.camel@localhost>
	 <200802210131.54272.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Feb 2008 11:04:54 +0100
Message-Id: <1203588294.3882.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 01:31 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 20 of February 2008, Soeren Sonnenburg wrote:
> > On Wed, 2008-02-20 at 00:50 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > > > On Tue, 2008-02-19 at 22:06 +0100, Rafael J. Wysocki wrote:
> > > > > On Tuesday, 19 of February 2008, Soeren Sonnenburg wrote:
> > > > > > Hi,
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > > since 2.6.25-rc1 (first version I tried) and still in rc2
> (and git), I
> > > > > > see a hang on s2ram already when trying to suspend.
> > > > > 
> > > > > Does it work with 2.6.24?
> > > > 
> > > > yes.
> > > 
> > > Please take the current mainline (there are a couple of nasty bugs
> fixed in
> > > it), configure it with CONFIG_PM_DEBUG set, boot it with
> "no_console_suspend",
> > > run
> > > 
> > > # echo 8 > /proc/sys/kernel/printk
> > > # echo devices > /sys/power/pm_test
> > > # echo mem > /sys/power/state
> > > 
> > > If it hangs, it should leave a stack trace before and I need that trace to see
> > > what's going on.  If it doesn't hang, I'll tell you what to do next.
> > 
> > I tried with 2.6.24.2 with CONFIG_PM_DEBUG set, following your steps and
> > yes it works flawlessly (though the display did not come back I could
> > suspend/resume multiple times without problems, and finally s2ram -f -p
> > brought the display back).
> 
> Hm, there's no /sys/power/pm_test in 2.6.24.2 (and the "current mainline"
> means the latest -git kernel possible or the current top of the Linus' tree),
> so in fact you tested 2.6.24 again, that is known to work ...

Great :( 

Anyway testing linus' git-current, I see that it does not hang. However
after the echo mem >/sys/power/state I am seeing:
[...]
PM: Finishing wakeup.
Restarting tasks ... done.
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: device not ready (errno=-16), forcing hardreset


and this a couple of times. Using echo none >/sys/power/pm_test and then
echo mem >/sys/power/state I see it hang on ata1 errors again. Waiting
about 10-30 seconds it progresses further and finally arrives at 

CPU0 attaching NULL sched-domain
CPU1 attaching NULL sched-domain

then hangs.

So what next?
Soeren
