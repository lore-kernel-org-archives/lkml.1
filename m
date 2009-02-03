Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZBCW0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZBCW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZBCW0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:26:31 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:34548 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZBCW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:26:30 -0500
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>
Subject: Acer 6592 TM, suspend to ram and resume freeze
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 03 Feb 2009 21:36:19 +0100
Message-ID: <873aevl0l8.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, sorry for the duplicate on linux-pm, but as Pavel suggested, this
topic gains wider audience as acpi and pm are involved.

I have an issue with my laptop with suspend to ram.
My laptop is an Acer Travelmate 6592g :

> [rj@velvet wireshark-1.0.5 (master)]$ sudo s2ram -i
> This machine can be identified by:
>     sys_vendor   = "Acer"
>     sys_product  = "TravelMate 6592"
>     sys_version  = "PSMBOU-1234567"
>     bios_version = "V1.53   "

The kernel running is the last I have : 2.6.29-rc1, but the problem is the same
whatever the kernel version I take (between 2.6.16 and 2.6.29-rc1).

The issue is that even if the laptop enters suspend correctly, it hangs on
comming out of it. After some research, I cornered down the module which changes
the behaviour : acpi_cpufreq.ko.

When I forbid the laptop to load this module, the suspend to ram works like a
charm, in "init" single mode or multi-user mode. When I load the module, the
resume always hangs (fan goes high speed like crazy, no LCD back, hard drive led
stays on, caps_lock key not responsive, ...)

Now, I notice that loading acpi-cpufreq triggers the following message :
> log: Jan 19 18:23:42 velvet kernel: ACPI: EC: non-query interrupt received, switching to interrupt mode

As this is not the part of the kernel I'm most at ease with, I'd like some help
to investigate. I'll gladly make any test or apply patches to my own git tree.

I join to this mail a URL [1] to see the little information I have :
 - kernel messages (/var/log/messages), for single user startup
 - ACPI table
 - my kernel configuration
 - kernel message for a working suspend to ram (ie. without acpi_cpufreq).
 - I suspend using s2ram -f -v -p -s

Best regards.

--
Robert

[1] http://belgarath.hd.free.fr/download/acer6592tm/
