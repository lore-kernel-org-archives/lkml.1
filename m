Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXDOTed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXDOTed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXDOTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:34:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54191 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXDOTec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:34:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 21:37:53 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dtor@insightbb.com>, pavel@suse.cz,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151753.00584.rjw@sisk.pl> <20070415184959.GA26517@melchior.yamamaya.is-a-geek.org>
In-Reply-To: <20070415184959.GA26517@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152137.54574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 April 2007 20:50, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 15 April 2007 16:19, Dmitry Torokhov wrote:
> > > On Sunday 15 April 2007 07:16, Rafael J. Wysocki wrote:
> > > > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > > > 
> > > > > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > > > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > > > > This is kinda interesting because I'm normally using a USB keyboard
> > > > > > and sure enough, if I hook up a normal keyboard and disable USB
> > > > > > legacy support in the BIOS, then suspend to disk works multiple
> > > > > > times. I'd still rather like to use my USB keyboard though. ;)
> > > > 
> > > > Well, I think that when you're using the USB keyboard and the USB legacy
> > > > support, the i8042 driver thinks it has a keyboard to handle and tries to
> > > > handle it during the suspend, which fails.  I don't know why it fails during
> > > > the second suspend, though.
> > > > 
> > > > Dmitry, could you please have a look?
> > > > 
> > > 
> > > This is wierd as i8042 does not use suspend_late/resume_early hooks and
> > > so it is impossible for it to hang there. None of input drivers use these
> > > hooks. Could it be that some other driver _after_ i8042 hangs?
> > 
> > Yes.
> > 
> > Tobias, can you please post the dmesg output from after a successful
> > suspend/resume cycle with CONFIG_PM_DEBUG=y in the 'platform' mode?
> 
> Here you go:

Thanks.

[--snip--]
> [10233.239209] swsusp: critical section: 
> [10233.253579] swsusp: Need to copy 125818 pages
> [10233.253688] swsusp: Normal pages needed: 125818 + 1024 + 22, available pages: 135940
> [   43.795445] Extended CMOS year: 2000
> [   43.798813] svm_cpu_init: svm_data is NULL on 0
> [   43.800886] pci 0000:00:00.0: EARLY resume
> [   43.800994] pci 0000:00:01.0: EARLY resume
> [   43.801102] nForce2_smbus 0000:00:01.1: EARLY resume
> [   43.801210] pci 0000:00:01.2: EARLY resume
> [   43.801317] ohci_hcd 0000:00:02.0: EARLY resume
> [   43.801425] ehci_hcd 0000:00:02.1: EARLY resume
> [   43.801532] pata_amd 0000:00:04.0: EARLY resume
> [   43.801640] pci 0000:00:06.0: EARLY resume
> [   43.801747] pci 0000:00:06.1: EARLY resume
> [   43.801854] forcedeth 0000:00:08.0: EARLY resume
> [   43.801962] forcedeth 0000:00:09.0: EARLY resume
> [   43.802070] pcieport-driver 0000:00:0a.0: EARLY resume
> [   43.802177] pcieport-driver 0000:00:0b.0: EARLY resume
> [   43.802289] pcieport-driver 0000:00:0c.0: EARLY resume
> [   43.802398] pcieport-driver 0000:00:0d.0: EARLY resume
> [   43.802506] pcieport-driver 0000:00:0e.0: EARLY resume
> [   43.802613] pcieport-driver 0000:00:0f.0: EARLY resume
> [   43.802721] pci 0000:00:18.0: EARLY resume
> [   43.802828] pci 0000:00:18.1: EARLY resume
> [   43.802935] pci 0000:00:18.2: EARLY resume
> [   43.803043] k8temp 0000:00:18.3: EARLY resume
> [   43.803150] e100 0000:01:07.0: EARLY resume
> [   43.803257] EMU10K1_Audigy 0000:01:08.0: EARLY resume
> [   43.803365] Emu10k1_gameport 0000:01:08.1: EARLY resume
> [   43.803473] pci 0000:01:0b.0: EARLY resume
> [   43.803580] ahci 0000:06:00.0: EARLY resume
> [   43.803695] pci 0000:06:00.1: EARLY resume
> [   43.803802] pci 0000:07:00.0: EARLY resume
> [   43.803910] pci 0000:07:00.1: EARLY resume
> [   43.804018] platform bluetooth: EARLY resume
> [   43.804126] platform pcspkr: EARLY resume
> [   43.804233] platform vesafb.0: EARLY resume
> [   43.804348] i8042 i8042: EARLY resume
> [   43.804460] PM: Image restored successfully.
> [   43.924837] acpi acpi_system:00: resuming
> [   43.924946] button button_power:00: resuming
> [   43.925054] processor ACPI0007:00: resuming
> [   43.925161] processor ACPI0007:01: resuming
> [   43.925268] acpi device:00: resuming
[--snip--]

Hmm, it looks like i8042 is the last thing on the dpm_off_irq list.  Still,
if the ACPI resume fails, the next messages may not make it to the console
(it's not very probable, though).

I've tried to reproduce your problem on another box on which I have no PS/2
keyboard (USB keyboard/mouse only) and the USB legacy support set, but I can't.
There must be something very special in your configuration.

Have you tried the patch that I posted some time ago (appended again for
convenience)?

Rafael


 drivers/input/serio/i8042.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc6/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.21-rc6.orig/drivers/input/serio/i8042.c	2007-04-07 12:15:19.000000000 +0200
+++ linux-2.6.21-rc6/drivers/input/serio/i8042.c	2007-04-15 18:30:01.000000000 +0200
@@ -846,7 +846,8 @@ static long i8042_panic_blink(long count
 static int i8042_suspend(struct platform_device *dev, pm_message_t state)
 {
 	if (dev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
+		if (state.event == PM_EVENT_SUSPEND
+		    || state.event == PM_EVENT_PRETHAW)
 			i8042_controller_reset();
 
 		dev->dev.power.power_state = state;
