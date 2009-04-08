Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZDHKvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZDHKvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDHKvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:51:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62914 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZDHKvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hULpYT3tbefAI+TGNs4S5q3Mkl4IJJiYN0+k4flBJpphkzmdF2T1jHLc0X4bgqqC4M
         KDSFQJgpFNmorKEvitZuy1/BAb4NmnTCfS3g6QfgZLor6ik2GzSS6VMVXiSFM70Lji7O
         MkSdWnVtn+xAwYbKPi9v83tUSYoRNGjggM3Os=
MIME-Version: 1.0
In-Reply-To: <208cbae30904080338x749800b0o392886ab023018b6@mail.gmail.com>
References: <208cbae30904080338x749800b0o392886ab023018b6@mail.gmail.com>
Date: Wed, 8 Apr 2009 12:51:29 +0200
Message-ID: <5a4c581d0904080351m6811ab81i59c9bc1043071d3@mail.gmail.com>
Subject: Re: commit "ACPI: battery: asynchronous init" brokes my boot up 
	process
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 12:38 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello,
>
> I don't know if i do right thing creating this letter but looks like
> this commit 0f66af530116e9f4dd97f328d91718b56a6fc5a4 "ACPI: battery:
> asynchronous init" brokes my boot up process. My machine is pentium-m
> cpu, Gentoo, gcc 4.3.3-r2.

Vegard Nossum posted a patch that fixes this problem, it's
 currently applied in Len Brown's tree so it should soon
 appear in the mainline kernel:

http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/03127.html

> When openRC started and i got something like "Processing udev
> events(?)" (i can't see exactly words) i got this:
>
> ACPI: Battery Slot [BAT1] (battery present)
> BUG: unable to handle kernel paging request at f8530030
> IP: [<f8530030>] 0xf8530030
> *pde = 37288067 *pte = 00000000
> Oops: 0000 [#1]
> last sysfs file: /sys/devices/pnp0/00:07/id
> Modules linked in: ehci_hcd(+) sg container(+) battery uhci_hcd
> thermal button ac usbhid hid cpufreq_ondemand acpi_cpufreq
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
> snd_timer snd soundcore snd_page_alloc usbcore rtc_cmos rtc_core
> rtc_lib
>
> Pid: 913, comm: async/0 Not tainted (2.6.29 #34) TravelMate 2350
> EIP: 0060:[<f8530030>] EFLAGS: 00010246 CPU: 0
> EIP is at 0xf8530030
> EAX: 00000000 EBX: 00000216 ECX: 00000001 EDX: 00000000
> ESI: c0129c47 EDI: f64bb5a0 EBP: 00000000 ESP: f660dfb0
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process async/0 (pid: 913, ti=f660d000 task=f6574d40 task.ti=f660d000)
> Stack:
>  c0129d1e f7035f88 00000296 00000000 f6574d40 c0115dd2 f7035fc8 c0369bc0
>  00000000 00000000 c0125c76 c0125c40 00000000 c0102f23 f7035f7c 00000000
>  00000000 00000000 00005067 003c8067
> Call Trace:
>  [<c0129d1e>] ? async_thread+0xd7/0x1a8
>  [<c0115dd2>] ? default_wake_function+0x0/0x8
>  [<c0125c76>] ? kthread+0x36/0x5a
>  [<c0125c40>] ? kthread+0x0/0x5a
>  [<c0102f23>] ? kernel_thread_helper+0x7/0x10
> Code:  Bad EIP value.
> EIP: [<f8530030>] 0xf8530030 SS:ESP 0068:f660dfb0
> CR2: 00000000f8530030
> ---[ end trace d9fadf449e253313 ]---
> ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0080000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>
> And boot up process freezes when system tries to restart udev later.
> I didn't  have this issue in 2.6.29-git12. It presented in
> 2.6.29-git15 and 2.6.30-rc1.
> Firstly i thought that there is conflict(or race) with usb modules,
> and i tried to unplug all my usb devices before reboot, but issue
> still present in 2.6.30-rc1.
>
> Well, then i removed many apci modules like button, fan, battery,
> thermal and finally figured out that battery module is buggy on my
> system.
> I cancel changes provided by this commit in drivers/acpi/battery.c
> file and re-compiled modules. Boot up started to works fine.
>
> Probably this happens due to: 1) cos my notebook too old and battery
> isn't works long, 2) Gentoo' boot up process is bad.
> May be kernel option in menuconfig can be appropriate?
>
> --
> Best regards, Klimov Alexey

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
