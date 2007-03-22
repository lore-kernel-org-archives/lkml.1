Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXCVJ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXCVJ2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXCVJ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:28:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbXCVJ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:28:48 -0400
Date: Thu, 22 Mar 2007 01:28:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1 + 4 hotfixes -- BUG: unable to handle kernel
 paging request at virtual address 6b6b6ceb -- EIP is at module_put+0x7/0x1f
Message-Id: <20070322012836.8e1a0d10.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703220114r42dd1954t3a4e1357d5ff71d6@mail.gmail.com>
References: <a44ae5cd0703220029lb4df507ne21da177f7c05008@mail.gmail.com>
	<20070321234456.946d1742.akpm@linux-foundation.org>
	<a44ae5cd0703220114r42dd1954t3a4e1357d5ff71d6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 01:14:41 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> I still encounter the BUG with the reverted patch.  In these two
> builds hitting the BUG, more stuff is built as a module, so perhaps
> that is why I am triggering this.  I am appending my .config file.
> 
> I hope this helps,
>           Miles
> 
> kobject drivers: registering. parent: ipw2200, set: <NULL>
> kobject_uevent_env
> kobject filter function caused the event to drop!
> kobject 0000:01:06.0: cleaning up
> kobject firmware: cleaning up
> BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
>  printing eip:
> c0137c22
> *pde = 00000000
> Oops: 0002 [#1]
> last sysfs file:
> devices/pci0000:00/0000:00:1e.0/0000:01:06.0/firmware/0000:01:06.0/loading
> Modules linked in: snd_pcm snd_seq_dummy sdhci snd_seq_oss rng_core
> ipw2200 snd_seq_midi_event snd_seq snd_timer snd_s
> eq_device mmc_core tifm_7xx1 tifm_core fw_ohci fw_core ieee80211
> ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_co
> re snd soundcore shpchp iTCO_wdt snd_page_alloc pci_hotplug psmouse
> rtc iTCO_vendor_support intel_agp agpgart evdev ex
> t3 jbd mbcache sg sr_mod cdrom sd_mod pata_acpi ata_piix ohci1394
> ieee1394 8139too mii libata scsi_mod ehci_hcd uhci_h
> cd usbcore thermal processor fan
> CPU:    0
> EIP:    0060:[<c0137c22>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.21-rc4-mm1 #5)
> EIP is at module_put+0x7/0x1f
> eax: 6b6b6b6b   ebx: c354d628   ecx: c01618d2   edx: 00000001
> esi: c39f5000   edi: c1e47d4c   ebp: c1fa3f38   esp: c1fa3f38
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process firmware_helper (pid: 1888, ti=c1fa2000 task=c1cab570 task.ti=c1fa2000)
> Stack: c1fa3f48 c019db66 00000008 c3548038 c1fa3f70 c0165eee 00000000 00000000
>        c39aea18 c1c12118 c3548038 c1e47d4c c1e13b14 00000000 c1fa3f80 c0166036
>        c1e47d4c c1e47d4c c1fa3f98 c0163ac6 c1e13b38 00000003 c1e13b14 c1e13b38
> Call Trace:
>  [<c0104c22>] show_trace_log_lvl+0x1a/0x2f
>  [<c0104cd2>] show_stack_log_lvl+0x9b/0xaa
>  [<c0104e97>] show_registers+0x1b6/0x288
>  [<c010505d>] die+0xf4/0x209
>  [<c0114b20>] do_page_fault+0x45d/0x529
>  [<c028a0fc>] error_code+0x74/0x7c
>  [<c019db66>] release+0x2a/0x37
>  [<c0165eee>] __fput+0xbe/0x168
>  [<c0166036>] fput+0x31/0x35
>  [<c0163ac6>] filp_close+0x54/0x5c
>  [<c0164a97>] sys_close+0x6f/0xa7
>  [<c0103c94>] sysenter_past_esp+0x5d/0x99
>  =======================
> Code: fe ff 8b 86 c4 00 00 00 e8 42 e4 08 00 89 f8 e8 22 e4 08 00 89
> f8 e8 d4 e2 08 00 59 89 d8 5b 5b 5e 5f 5d c3 55 8
> 5 c0 89 e5 74 16 <ff> 88 80 01 00 00 83 38 02 75 0b 8b 80 08 02 00 00
> e8 9c ee fd
> EIP: [<c0137c22>] module_put+0x7/0x1f SS:ESP 0068:c1fa3f38
> kobject pcmcia: registering. parent: <NULL>, set: module
> kobject holders: registering. parent: pcmcia, set: <NULL>
> kobject_uevent_env
> 

Marvellous.

I cannot reproduce it with my current lineup.  Maybe someone fixed it in
one of the subsystem trees.

If you have time, could you please test
http://userweb.kernel.org/~akpm/ml.bz2 (against 2.6.21-rc4).



It surprises me that ipw2200 does this:

[  104.284000] kobject 'ipw2200' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.

