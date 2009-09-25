Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZIYGaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZIYGaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIYGaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:30:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39001 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZIYGaU (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Fri, 25 Sep 2009 02:30:20 -0400
Message-ID: <4ABC63C4.8060704@suse.de>
Date: Fri, 25 Sep 2009 12:01:32 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: cifs oops at mount in linus git
References: <200909221637.57722.a.miskiewicz@gmail.com> <20090924165303.1fc4fc76@tlielax.poochiereds.net>
In-Reply-To: <20090924165303.1fc4fc76@tlielax.poochiereds.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> On Tue, 22 Sep 2009 16:37:57 +0200
> Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
> 
>> This oops is happening in latest linus master. Few days ago there
>> was no such problem. Is this anything known?
>>
>> [50421.547540] general protection fault: 0000 [#1] PREEMPT SMP                                                                                               
>> [50421.547544] last sysfs file: /sys/class/power_supply/BAT0/energy_full                                                                                     
>> [50421.547546] CPU 0
>> [50421.547547] Modules linked in: nls_utf8 cifs iwlagn sco bridge stp llc xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables tun input_polldev 
>> rfcomm bnep l2cap crc16 ipv6 sch_sfq acpi_cpufreq cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt btusb bluetooth dm_mod usbhid hid uvcvideo videodev v4l1_compat 
>> v4l2_compat_ioctl32 joydev snd_hda_codec_conexant arc4 ecb snd_hda_intel snd_hda_codec iwlcore mac80211 snd_hwdep snd_pcm snd_timer uhci_hcd ehci_hcd yenta_socket firewire_ohci 
>> cfg80211 sdhci_pci thinkpad_acpi snd psmouse sdhci firewire_core rfkill sg mmc_core rsrc_nonstatic soundcore usbcore evdev pcspkr processor serio_raw sr_mod snd_page_alloc ricoh_mmc 
>> crc_itu_t pcmcia_core e1000e nvram cdrom iTCO_wdt i2c_i801 iTCO_vendor_support led_class wmi thermal battery ac xfs exportfs sd_mod crc_t10dif ahci libata scsi_mod [last unloaded: iwlagn]
>> [50421.547607] Pid: 24094, comm: mount.cifs Not tainted 2.6.31 #36 2764CTO
>> [50421.547609] RIP: 0010:[<ffffffffa04e572e>]  [<ffffffffa04e572e>] cifs_get_tcp_session+0x411/0x572 [cifs]
>> [50421.547621] RSP: 0018:ffff880116439b98  EFLAGS: 00010287
>> [50421.547623] RAX: ffff880116438000 RBX: ffff8801164e1400 RCX: 0000000000000000
>> [50421.547625] RDX: ffff10016133db00 RSI: 0000000000000206 RDI: ffffffff8125cdc6
>> [50421.547626] RBP: ffff880116439c58 R08: ffff880116438000 R09: ffff880028213e00
>> [50421.547628] R10: ffffffff81487dd8 R11: 0000000000000005 R12: ffff880064d2eb80
>> [50421.547630] R13: ffff880116439ba8 R14: ffff8801164e1400 R15: 0000000000000000
>> [50421.547633] FS:  00007f1bbc0ca6f0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
>> [50421.547635] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [50421.547637] CR2: 00007f4741e20340 CR3: 00000001164b9000 CR4: 00000000000006f0
>> [50421.547639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [50421.547641] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [50421.547643] Process mount.cifs (pid: 24094, threadinfo ffff880116438000, task ffff88013ad38000)
>> [50421.547645] Stack:
>> [50421.547646]  0000000000000000 ffffffff0000000d 9200a8c000000002 0000000000000000
>> [50421.547649] <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [50421.547652] <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [50421.547655] Call Trace:
>> [50421.547665]  [<ffffffffa04e76d6>] cifs_mount+0x18a3/0x23c9 [cifs]
>> [50421.547673]  [<ffffffffa04da93b>] cifs_get_sb+0x181/0x2d3 [cifs]
>> [50421.547678]  [<ffffffff810d5626>] vfs_kern_mount+0x9e/0x12a
>> [50421.547681]  [<ffffffff810d5710>] do_kern_mount+0x48/0xe8
>> [50421.547684]  [<ffffffff810eaf24>] do_mount+0x785/0x7f2
>> [50421.547687]  [<ffffffff810eb019>] sys_mount+0x88/0xc7
>> [50421.547691]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
>> [50421.547692] Code: 48 8b 04 25 08 b5 00 00 48 2d d8 1f 00 00 ff 40 1c 65 8b 0c 25 30 cc 00 00 48 8b 15 f5 d6 02 00 48 63 c9 48 03 14 cd 60 5c 4e 81 <48> ff 02 48 8b 15 e0 d6 02 00 48 03 
>> 14 cd 60 5c 4e 81 83 3d 81
>> [50421.547718] RIP  [<ffffffffa04e572e>] cifs_get_tcp_session+0x411/0x572 [cifs]
>> [50421.547732]  RSP <ffff880116439b98>
>> [50421.547734] ---[ end trace cc36b55daefbf636 ]---
>> [50421.547736] note: mount.cifs[24094] exited with preempt_count 2
>>
> 

I couldn't reproduce this in my setup too. What mount options you are
using? Do you use ipv6? Is this reproducible during every mount or
consistently?

Trying to decode the Code on 2.6.31 cifs.ko leads me to somewhere near
cifsd thread handling code later in the function cifs_get_tcp_session()
but I fail to see any obvious problems there.

> 
> Not one I've seen. What mount options are you passing for this mount?
> 
> There's only been one patch in this area recently:
> 
> commit bdb97adcdf0993adbd2eef44b4533620d43792de
> Author: Suresh Jayaraman <sjayaraman@suse.de>
> Date:   Thu Aug 20 13:03:34 2009 +0530
> 
>     PATCH] cifs: fix broken mounts when a SSH tunnel is used (try #4)
> 
> ...I don't see any obvious bugs there, but it is a little more nested
> than it could be. Could you send me the cifs.ko for the kernel that
> generated this oops? Might be interesting to disassemble it and see
> where it fell down.
> 

Thanks,

-- 
Suresh Jayaraman
