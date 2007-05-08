Return-Path: <linux-kernel-owner+w=401wt.eu-S1031345AbXEHTOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031345AbXEHTOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031324AbXEHTOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:14:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031288AbXEHTO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:14:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.21 -- Lid button won't initiate suspend. Also, suspend didn't enter low-power state until I touched my mousepad.
Date: Tue, 8 May 2007 21:19:02 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <a44ae5cd0705072334l1fe9afcs5eae4e684116a9c4@mail.gmail.com> <200705081232.50510.rjw@sisk.pl> <a44ae5cd0705080931p6fe5c7e4v8dfa509c72c08eaf@mail.gmail.com>
In-Reply-To: <a44ae5cd0705080931p6fe5c7e4v8dfa509c72c08eaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082119.03062.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 May 2007 18:31, Miles Lane wrote:
> On 5/8/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > On Tuesday, 8 May 2007 08:34, Miles Lane wrote:
> > > Firstly, all my attempts to get suspend to start by pressing my
> > > laptop's lid button are failing.
> > >
> > > Here's the log info from about eight attempts::
> >
> > linux-acpi added to the CC list.
> >
> > > [   66.080135] ACPI: AC Adapter [ACAD] (on-line)
> > > [   66.201949] ACPI: Battery Slot [BAT0] (battery present)
> > > [   66.237885] input: Power Button (FF) as /class/input/input2
> > > [   66.252274] ACPI: Power Button (FF) [PWRF]
> > > [   66.267691] input: Lid Switch as /class/input/input3
> > > [   66.280884] ACPI: Lid Switch [LID0]
> > > [   66.296423] input: Sleep Button (CM) as /class/input/input4
> > > [   66.309328] ACPI: Sleep Button (CM) [SLPB]
> > > [   66.324930] No dock devices found.
> > > [   66.369537] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > > [   66.386972] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
> > > [   50.683328] Time: acpi_pm clocksource has been installed.
> > > [   53.729994] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > > [   54.203327] eth0: link down
> > > [   55.933327] PM: Adding info for No Bus:vcs7
> > > [   55.933327] PM: Adding info for No Bus:vcsa7
> > > [   56.396661] ppdev: user-space parallel port driver
> > > [   56.449994] PM: Removing info for No Bus:vcs7
> > > [   56.449994] PM: Removing info for No Bus:vcsa7
> > > [   56.649994] PM: Adding info for No Bus:vcs7
> > > [   56.649994] PM: Adding info for No Bus:vcsa7
> > > [   57.483327] [drm] Initialized drm 1.1.0 20060810
> > > [   57.533327] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
> > > low) -> IRQ 18
> > > [   57.539994] [drm] Initialized i915 1.6.0 20060119 on minor 0
> > > [   57.543327] [drm] Initialized i915 1.6.0 20060119 on minor 1
> > > [   60.216660] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> > > [   60.219993] PM: Adding info for No Bus:apm_bios
> > > [   61.366660] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > > [   61.629993] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> > > recovery directory
> > > [   61.689993] NFSD: starting 90-second grace period
> > > [   62.766660] usb usb4: usb auto-resume
> > > [   62.766660] usb usb4: finish resume
> > > [   62.766660] hub 4-0:1.0: hub_resume
> > > [   62.769993] usb usb4: wakeup_rh
> > > [   62.806660] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   62.806660] usb usb3: usb auto-resume
> > > [   62.806660] usb usb3: finish resume
> > > [   62.806660] hub 3-0:1.0: hub_resume
> > > [   62.806660] usb usb3: wakeup_rh
> > > [   62.843327] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   62.843327] usb usb1: usb auto-resume
> > > [   62.843327] usb usb1: finish resume
> > > [   62.843327] hub 1-0:1.0: hub_resume
> > > [   62.843327] usb usb1: wakeup_rh
> > > [   62.879993] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   62.879993] usb usb2: usb auto-resume
> > > [   62.879993] usb usb2: finish resume
> > > [   62.879993] hub 2-0:1.0: hub_resume
> > > [   62.879993] ehci_hcd 0000:00:1d.7: resume root hub
> > > [   62.913327] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
> > > [   63.269993] Clocksource tsc unstable (delta = -166083281 ns)
> > > [   63.796660] usb usb4: suspend_rh (auto-stop)
> > > [   63.833326] usb usb3: suspend_rh (auto-stop)
> > > [   63.869993] usb usb1: suspend_rh (auto-stop)
> > > [   64.806660] hub 4-0:1.0: hub_suspend
> > > [   64.806660] usb usb4: suspend_rh
> > > [   64.806660] usb usb4: usb auto-suspend
> > > [   64.843326] hub 3-0:1.0: hub_suspend
> > > [   64.843326] usb usb3: suspend_rh
> > > [   64.843326] usb usb3: usb auto-suspend
> > > [   64.879993] hub 1-0:1.0: hub_suspend
> > > [   64.879993] usb usb1: suspend_rh
> > > [   64.879993] usb usb1: usb auto-suspend
> > > [   64.913326] hub 2-0:1.0: hub_suspend
> > > [   64.913326] ehci_hcd 0000:00:1d.7: suspend root hub
> > > [   64.913326] usb usb2: usb auto-suspend
> > > [   68.549993] usb usb4: usb auto-resume
> > > [   68.549993] usb usb4: finish resume
> > > [   68.553326] hub 4-0:1.0: hub_resume
> > > [   68.553326] usb usb4: wakeup_rh
> > > [   68.593326] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   68.593326] usb usb3: usb auto-resume
> > > [   68.596659] usb usb3: finish resume
> > > [   68.599993] hub 3-0:1.0: hub_resume
> > > [   68.599993] usb usb3: wakeup_rh
> > > [   68.626659] Bluetooth: Core ver 2.11
> > > [   68.626659] PM: Adding info for platform:bluetooth
> > > [   68.629993] NET: Registered protocol family 31
> > > [   68.629993] Bluetooth: HCI device and connection manager initialized
> > > [   68.629993] Bluetooth: HCI socket layer initialized
> > > [   68.683326] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   68.686659] usb usb1: usb auto-resume
> > > [   68.686659] usb usb1: finish resume
> > > [   68.686659] hub 1-0:1.0: hub_resume
> > > [   68.686659] usb usb1: wakeup_rh
> > > [   68.723326] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > > [   68.723326] usb usb2: usb auto-resume
> > > [   68.723326] usb usb2: finish resume
> > > [   68.723326] hub 2-0:1.0: hub_resume
> > > [   68.723326] ehci_hcd 0000:00:1d.7: resume root hub
> > > [   68.746659] Bluetooth: L2CAP ver 2.8
> > > [   68.746659] Bluetooth: L2CAP socket layer initialized
> > > [   68.763326] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
> > > [   68.826659] Bluetooth: RFCOMM socket layer initialized
> > > [   68.826659] Bluetooth: RFCOMM TTY layer initialized
> > > [   68.826659] Bluetooth: RFCOMM ver 1.8
> > > [   69.583326] usb usb4: suspend_rh (auto-stop)
> > > [   69.673326] usb usb3: suspend_rh (auto-stop)
> > > [   69.713326] usb usb1: suspend_rh (auto-stop)
> > > [   70.593326] hub 4-0:1.0: hub_suspend
> > > [   70.593326] usb usb4: suspend_rh
> > > [   70.593326] usb usb4: usb auto-suspend
> > > [   70.686659] hub 3-0:1.0: hub_suspend
> > > [   70.686659] usb usb3: suspend_rh
> > > [   70.686659] usb usb3: usb auto-suspend
> > > [   70.689992] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > > [   73.759992] hub 1-0:1.0: hub_suspend
> > > [   73.759992] usb usb1: suspend_rh
> > > [   73.759992] usb usb1: usb auto-suspend
> > > [   73.759992] hub 2-0:1.0: hub_suspend
> > > [   73.759992] ehci_hcd 0000:00:1d.7: suspend root hub
> > > [   73.759992] usb usb2: usb auto-suspend
> > > [   89.083324] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > > [   91.086657] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > > [   93.116657] NET: Registered protocol family 10
> > >
> > > Then I tried initiating a suspend from the Gnome System menu.  The
> > > suspend proceeded until the screen went black, but the disk stayed
> > > spun up and the LEDs on the keyboards stayed lit up.  When I touched
> > > the synaptics mousepad, the system entered the low power state.
> >
> > Did it wake up?  Your log ends at the "early resume" stage.
> 
> Yes.  I just cut out the part I thought might be helpful.  If you want
> another test with a full dmesg, I will be happy to send that along.
> 
> > > On subsequent attempts to enter the suspend state, I didn't need to
> > > touch the mouse to get it to work.
> > >
> > > Here is the log information from the flawed suspend process.  I don't
> > > see anything indicating the mousepad activity:
> >
> > It probably only generated an interrupt that allowed the system to complete
> > the suspend.
> >
> > Do you have CONFIG_NO_HZ set?
> 
> Yes.  I could rebuild with that unset and see what happens.

Please do that.

Greetings,
Rafael

PS
Please keep the CC list when you reply, thanks.
