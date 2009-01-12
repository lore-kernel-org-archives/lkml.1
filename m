Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZALMlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZALMlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZALMlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:41:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZALMlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:41:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Date: Mon, 12 Jan 2009 13:40:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <200901120903.20371.rjw@sisk.pl> <c4e36d110901120414q22d76501r10d643efeea8c65c@mail.gmail.com>
In-Reply-To: <c4e36d110901120414q22d76501r10d643efeea8c65c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121340.21009.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Zdenek Kabelac wrote:
> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Sunday 11 January 2009, Zdenek Kabelac wrote:
> >> 2009/1/11 Maciej Rutecki <maciej.rutecki@gmail.com>:
> >> > 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >> >> Hi
> >> >>
> >> >> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
> >> >>
> >> >> I've observed that suspend is unusable - it goes to sleep - the sleep
> >> >> LED is on. After few secs system turns on back itself - and stays in
> >> >> some frozen state
> >> >
> >> > A have similar situation, one difference: I get blank screen during
> >> > resume from suspend to ram. Also sometimes, like You, system turns on
> >> > back itself.
> >> >
> >>
> >> So it looks like reverting this commit:
> >>
> >> http://marc.info/?l=linux-kernel&m=123140019117968&w=4
> >> (6fd9086a518d4f14213a32fe6c9ac17fabebbc1e)
> >> (which is already a tracked regression)
> >> fixes the problem with auto-resume
> >>
> >> But the problem with deadlock in the resume phase is still there.
> >
> > Please check if unloading all of the USB controller modules before suspend
> > helps.
> 
> I've booted to single mode without   usbcore module (thus any load of
> other usb modules fails)
> (removed from initramdisk as well)
> 
> This time the resume stops with these 3 lines (I'm using
> no_console_suspend kernel option):
> 
> ....
> thinkpad_acpi  thinkpad_acpi: EARLY resume
> thinkpad_hwmon  thinkpad_hwmon: EARLY resume
> Enabling non-boot CPUs...

So it seems we have broken CPU hotplug again.

Does disabling/enabling CPU1 using
/sys/devices/system/cpu/cpu1/online work?

If it does, please boot with 'no_console_suspend' in the kernel command line,
run:

# echo core > /sys/power/pm_test
# echo 8 > /proc/sys/kernel/printk
# echo mem > /sys/power/state

and see what happens (you need to have PM_DEBUG set in the kernel .config).

Please send dmesg output generated right after the above (if it works).

Thanks,
Rafael
