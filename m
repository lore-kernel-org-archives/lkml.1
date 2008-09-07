Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYIGPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYIGPY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIGPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:24:47 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:59246 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYIGPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=u3oXg802R0E+0X1JW5DzLABxfluSyHfq0NvrF4e6lFROP3Ky8ZSfrVRteZnAn15RQb
         aaZ730q/KzTaX87765D+K2AQq3oJcs4w9NMLCFZGchkO88jBhbbcgfERN5mnDv6O9+/R
         bR9izsdEJtgzj4cE8bq0qfw9ivc95X79NENVE=
Message-ID: <48C3F237.1020503@tuffmail.co.uk>
Date: Sun, 07 Sep 2008 16:24:39 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
References: <patchbomb.1220777491@localhost>
In-Reply-To: <patchbomb.1220777491@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi Ingo,
>
> This series implements a check and workaround for memory corruption in
> low memory.
>
> The first patch adds the basic mechanism.  The second adds some
> enchancements from Hugh, namely periodic scanning for badness.  The
> third tidies the user interface up by adding a proper Kconfig option
> and several kernel command-line parameters to enable the feature and
> control the amount of memory it scans and how often.  It also uses a
> WARN() with the intention of getting any output into ksymoops.org.
>
> I've tested it as far as I can, but none of my systems seem to exhibit
> this type of corruption so I haven't seen the failure case output.  I
> hope Alan and Rafał can test this version of the patch and report it
> does the expected thing.
>
> [ Hugh - I took the liberty of splitting your patch up into a delta on
>   top of mine, moving the pure bugfixes into my base patch, and
>   putting your additional code into the new patch From you with your
>   sign-off from the original patch, and adding my own sob to reflect
>   the changes I made.  I hope you don't mind. ]
>
> Thanks,
> 	J
>   

Seems to work ok. 

(And here's the output, for the benefit of Google / kerneloops.org).

[   84.140181] Back to C!
[   84.140181] Corrupted low memory at ffff8800000083e8 (83e8 phys) =
803c85370cfc0000
[   84.140181] Corrupted low memory at ffff8800000083f0 (83f0 phys) =
00003000
[   84.140181] ------------[ cut here ]------------
[   84.140181] WARNING: at arch/x86/kernel/setup.c:698
check_for_bios_corruption+0xd9/0xe0()
[   84.140181] Memory corruption detected in low memory
[   84.140181] Modules linked in:
[   84.140181] Pid: 7813, comm: s2ram Not tainted
2.6.27-rc5-00322-gb84d508 #160
[   84.140181]
[   84.140181] Call Trace:
[   84.140181]  [<ffffffff80238a87>] warn_slowpath+0xb7/0xe0
[   84.140181]  [<ffffffff802524f6>] ? down_trylock+0x36/0x50
[   84.140181]  [<ffffffff80239330>] ? try_acquire_console_sem+0x10/0x40
[   84.140181]  [<ffffffff80212b69>] ? read_tsc+0x9/0x20
[   84.140181]  [<ffffffff80253eca>] ? getnstimeofday+0x3a/0xc0
[   84.140181]  [<ffffffff80239c07>] ? printk+0x67/0x70
[   84.140181]  [<ffffffff8036f3e3>] ? acpi_os_release_lock+0x9/0xb
[   84.140181]  [<ffffffff8037d75c>] ? acpi_set_register+0x161/0x173
[   84.140181]  [<ffffffff8020fe69>] check_for_bios_corruption+0xd9/0xe0
[   84.140181]  [<ffffffff803c1db9>] pm_dev_dbg+0x9/0x10
[   84.140181]  [<ffffffff803c28f2>] dpm_power_up+0x32/0xf0
[   84.140181]  [<ffffffff803c2b47>] device_power_up+0x17/0x20
[   84.140181]  [<ffffffff80261e6c>] suspend_devices_and_enter+0x16c/0x190
[   84.140181]  [<ffffffff8026205c>] enter_state+0x19c/0x1b0
[   84.140181]  [<ffffffff8026211f>] state_store+0xaf/0xf0
[   84.140181]  [<ffffffff803465b7>] kobj_attr_store+0x17/0x20
[   84.140181]  [<ffffffff802ff34b>] sysfs_write_file+0xeb/0x140
[   84.140181]  [<ffffffff802a9c87>] vfs_write+0xc7/0x180
[   84.140181]  [<ffffffff802aa290>] sys_write+0x50/0x90
[   84.140181]  [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
[   84.140181]
[   84.140181] ---[ end trace e31222efe32d34ab ]---

