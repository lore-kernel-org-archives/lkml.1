Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXFJPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXFJPvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXFJPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:51:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:60386 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752640AbXFJPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:51:08 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+vHikiUSavcjBdSG43GwonAU+H62M7q9ZJmo23Sp
	QfFE7zzZZttGMj
Date: Sun, 10 Jun 2007 17:51:13 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl
Subject: Re: cat /dev/snapshot == OOPs
Message-ID: <20070610155113.GA10506@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Arkadiusz Miskiewicz <arekm@maven.pl>, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, rjw@sisk.pl
References: <200706101542.33951.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706101542.33951.arekm@maven.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.10 15:42:33 +0200, Arkadiusz Miskiewicz wrote:
> Hello,
> 
> Is this desired behaviour?
> 
> $ sudo cat /dev/snapshot
> 
> ended with:
> 
> [54498.464550] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
> dm-devel@redhat.com
> [56592.077674] swsusp: Basic memory bitmaps created
> [56592.084340] BUG: unable to handle kernel NULL pointer dereference at 
> virtual address 0000000c
> [56592.084340]  printing eip:
> [56592.084340] c0135a6e
> [56592.084340] *pde = 00000000
> [56592.084340] Oops: 0000 [#1]
> [56592.084340] Modules linked in: dm_snapshot dm_mod radeon drm binfmt_misc 
> ipv6 sch_sfq mmc_block rfcomm l2cap bluetooth ircomm_tty ircomm 
> cpufreq_ondemand acpi_cpufreq freq_table hdaps snd_pcm_oss snd_mixer_oss 
> video thermal processor fan container evdev button battery ac nvram 
> thinkpad_acpi hwmon backlight tun capability commoncap firewire_ohci 
> firewire_core crc_itu_t ahci pcmcia sdhci usbhid hid ff_memless ohci1394 
> mmc_core ata_generic ipw2200 ieee80211 ieee80211_crypt firmware_class 
> ieee1394 yenta_socket rsrc_nonstatic pcmcia_core nsc_ircc tg3 snd_hda_intel 
> generic i2c_i801 i2c_core ide_core snd_pcm snd_timer snd intel_agp iTCO_wdt 
> iTCO_vendor_support soundcore sr_mod psmouse agpgart snd_page_alloc serio_raw 
> uhci_hcd irda crc_ccitt ehci_hcd usbcore cdrom rtc_cmos rtc_core rtc_lib xfs 
> scsi_wait_scan sd_mod ata_piix libata scsi_mod
> [56592.084340] CPU:    0
> [56592.084340] EIP:    0060:[<c0135a6e>]    Not tainted VLI
> [56592.084340] EFLAGS: 00210206   (2.6.22-rc4 #70)
> [56592.084340] EIP is at snapshot_read_next+0xcf/0x1d7
> [56592.084340] eax: 00000000   ebx: d96fd200   ecx: c038e8f8   edx: e0688000
> [56592.084340] esi: c031c462   edi: e0688186   ebp: ee42df5c   esp: ee42df48
> [56592.084340] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> [56592.084340] Process cat (pid: 22965, ti=ee42c000 task=c7d55480 
> task.ti=ee42c000)
> [56592.084340] Stack: 00001000 c038e8f8 d96fd200 c038e8f8 0804e000 ee42df70 
> c0136ba5 d96fd200
> [56592.084340]        c0136b91 0804e000 ee42df90 c015b26b ee42df9c 00000006 
> 00001000 d96fd200
> [56592.084340]        fffffff7 0804e000 ee42dfb0 c015b5d3 ee42df9c 00000000 
> 00000000 00000000
> [56592.084340] Call Trace:
> [56592.084340]  [<c0104a50>] show_trace_log_lvl+0x1a/0x2f
> [56592.084340]  [<c0104b00>] show_stack_log_lvl+0x9b/0xa3
> [56592.084340]  [<c0104cbc>] show_registers+0x1b4/0x286
> [56592.084340]  [<c0104e6d>] die+0xdf/0x1b1
> [56592.084340]  [<c01148a0>] do_page_fault+0x424/0x4f0
> [56592.084340]  [<c027f90a>] error_code+0x6a/0x70
> [56592.084340]  [<c0136ba5>] snapshot_read+0x14/0x48
> [56592.084340]  [<c015b26b>] vfs_read+0xad/0x15f
> [56592.084340]  [<c015b5d3>] sys_read+0x3d/0x61
> [56592.084340]  [<c0103b8a>] sysenter_past_esp+0x5f/0x85
> [56592.084340]  =======================
> [56592.084340] Code: 03 05 b4 e8 38 c0 40 89 82 98 01 00 00 c1 e0 0c 89 82 9c 
> 01 00 00 a1 a0 e8 38 c0 8b 4d f0 89 41 14 a1 b8 e8 38 c0 a3 c0 e8 38 c0 <8b> 
> 40 0c c7 05 c8 e8 38 c0 00 00 00 00 c7 05 cc e8 38 c0 ff ff
> [56592.084340] EIP: [<c0135a6e>] snapshot_read_next+0xcf/0x1d7 SS:ESP 
> 0068:ee42df48
> [56592.101007] swsusp: Basic memory bitmaps freed

Looks like it is the access to zone_bm->bm_blocks aka
orig_bm.zone_bm_list->bm_blocks. zone_bm_list is NULL unless
swsusp_save() is called. I don't see any state variable that would allow
an obvious fix though, so I'll leave that to the swsusp guys.

Björn
