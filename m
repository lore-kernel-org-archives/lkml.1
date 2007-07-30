Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXG3PVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXG3PVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbXG3PV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:21:28 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:33320 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbXG3PV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:21:27 -0400
Date: Mon, 30 Jul 2007 11:20:40 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: ACPI on Averatec 2370
In-Reply-To: <46ACD8DB.2020108@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
 <46ACD8DB.2020108@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Gabriel C wrote:

> Frank Hale wrote:
> [ added  linux-acpi to CC ]
> > I have an Averatec 2370 laptop with the nVidia MCP51. With kernel
> > 2.6.20 I had no issues with ACPI however with 2.6.21 and higher the
> > kernel will hang on boot until I press the suspend button or the power
> > button in which case the kernel wakes up and finishes the boot
> > process. Including the following support only causes the issue:
> > 
> >  [*] ACPI Support
> > 
> > What I mean by that is every ACPI option has been deactivated and only
> > ACPI support checked. The boot process with 2.6.21 and higher hangs at
> > the point where the Scheduler is being registered.
> > 
> > io scheduler cfq registered (default)
> > 
> > If I allow it to sit there it never comes back to life and finishes
> > booting. If I press the power or suspend button it will finish booting
> > as expected.
> > 
> > I've scoured google for quite a while but cannot find any relevant
> > information pertaining to this issue. For now I've disabled ACPI
> > altogether.

Frank, thanks for the tip about 2.6.20 being good, it gave me a nice place 
to start bisecting from.

Thomas, Ingo,

Regarding the issue described above that Frank and I are having, I've 
narrowed it down to commit e9e2cdb4[1]: [PATCH] clockevents: i386 drivers

About our systems:
  Averatec 2370/2371 Laptop
    AMD Turion 64 X2 TL-50/TL-52
    nVidia MCP51 chipset

Here a small matrix of my tests:

2.6.20.15 SMP		: OK
2.6.21.5 SMP		: hang
2.6.21.5 UP w/o APIC	: OK
2.6.22.1 UP		: hang
2.6.22.1 UP w/o IO-APIC	: hang
2.6.22.1 UP w/o APIC	: OK
2.6.22.1 SMP		: hang
2.6.22.1 SMP w/o ACPI	: OK

Please let me know if there's anything else I can provide to help.

thanks!
-- 
Cal Peake

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e9e2cdb412412326c4827fc78ba27f410d837e6e
