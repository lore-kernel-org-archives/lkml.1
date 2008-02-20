Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYBTLRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYBTLRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 06:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYBTLQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 06:16:59 -0500
Received: from ns.suse.de ([195.135.220.2]:46055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYBTLQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 06:16:58 -0500
Message-ID: <47BC0C28.1030607@suse.de>
Date: Wed, 20 Feb 2008 12:16:56 +0100
From: Stefan Seyfried <seife@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.9) Gecko/20071114 SUSE/2.0.0.9-17 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bluez-devel] [BUG] rfcomm
References: <200710231950.31313.alon.barlev@gmail.com>	<a8e1da0802141928yabfd87ajfed0b009e1e79018@mail.gmail.com>	<a8e1da0802151513p34ad118i54ddd8f00e6e136@mail.gmail.com>	<200802162349.59780.alon.barlev@gmail.com> <20080220103611.GA4027@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080220103611.GA4027@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young schrieb:

>> Feb 16 23:41:33 alon1 BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
>> Feb 16 23:41:33 alon1 printing eip: c01b2db6 *pde = 00000000 
>> Feb 16 23:41:33 alon1 Oops: 0000 [#1] PREEMPT 
>> Feb 16 23:41:33 alon1 Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async rfcomm l2cap hci_usb vmnet(P) vmmon(P) tun radeon drm autofs4 ipv6 aes_generic crypto_algapi ieee80211_crypt_ccmp nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device bluetooth ppp_generic slhc ioatdma dca cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table uinput fan af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm nsc_ircc snd_timer ipw2200 thinkpad_acpi irda snd ehci_hcd yenta_socket uhci_hcd psmouse ieee80211 soundcore intel_agp hwmon rsrc_nonstatic pcspkr e1000 crc_ccitt snd_page_alloc i2c_i801 ieee80211_crypt pcmcia_core agpgart thermal b
a
>  ttery nvram rtc sr_mod ac sg firmware_class button processor cdrom unix usbcore evdev ext3 jbd ext2 mbcache loop ata_piix libata sd_mod scsi_mod
>> Feb 16 23:41:33 alon1 
>> Feb 16 23:41:33 alon1 Pid: 4, comm: events/0 Tainted: P        (2.6.24-gentoo-r2 #1)
>> Feb 16 23:41:33 alon1 EIP: 0060:[<c01b2db6>] EFLAGS: 00010282 CPU: 0
>> Feb 16 23:41:33 alon1 EIP is at sysfs_get_dentry+0x26/0x80
>> Feb 16 23:41:33 alon1 EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f48a2210
>> Feb 16 23:41:33 alon1 ESI: f72eb900 EDI: f4803ae0 EBP: f4803ae0 ESP: f7c49efc
>> Feb 16 23:41:33 alon1 hcid[7004]: HCI dev 0 registered
>> Feb 16 23:41:33 alon1 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Feb 16 23:41:33 alon1 Process events/0 (pid: 4, ti=f7c48000 task=f7c3efc0 task.ti=f7c48000)
>> Feb 16 23:41:33 alon1 Stack: f7cb6140 f4822668 f7e71e10 c01b304d ffffffff ffffffff fffffffe c030ba9c 
>> Feb 16 23:41:33 alon1 f7cb6140 f4822668 f6da6720 f7cb6140 f4822668 f6da6720 c030ba8e c01ce20b 
>> Feb 16 23:41:33 alon1 f6e9dd00 c030ba8e f6da6720 f6e9dd00 f6e9dd00 00000000 f4822600 00000000 
>> Feb 16 23:41:33 alon1 Call Trace:
>> Feb 16 23:41:33 alon1 [<c01b304d>] sysfs_move_dir+0x3d/0x1f0
>> Feb 16 23:41:33 alon1 [<c01ce20b>] kobject_move+0x9b/0x120
>> Feb 16 23:41:33 alon1 [<c0241711>] device_move+0x51/0x110
>> Feb 16 23:41:33 alon1 [<f9aaed80>] del_conn+0x0/0x70 [bluetooth]
>> Feb 16 23:41:33 alon1 [<f9aaed99>] del_conn+0x19/0x70 [bluetooth]
>> Feb 16 23:41:33 alon1 [<c012c1a1>] run_workqueue+0x81/0x140
>> Feb 16 23:41:33 alon1 [<c02c0c88>] schedule+0x168/0x2e0

> Could you try patch below?

Works fine for me. Thanks. Together with the other two patches already taken
by davem, this fixes all my current BT problems :-)

> Defer hci_unregister_sysfs because hci device could be destructed
> while hci conn devices still there.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> net/bluetooth/hci_core.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -upr linux/net/bluetooth/hci_core.c linux.new/net/bluetooth/hci_core.c
> --- linux/net/bluetooth/hci_core.c	2008-02-20 18:27:28.000000000 +0800
> +++ linux.new/net/bluetooth/hci_core.c	2008-02-20 18:28:34.000000000 +0800
> @@ -901,8 +901,6 @@ int hci_unregister_dev(struct hci_dev *h
>  
>  	BT_DBG("%p name %s type %d", hdev, hdev->name, hdev->type);
>  
> -	hci_unregister_sysfs(hdev);
> -
>  	write_lock_bh(&hci_dev_list_lock);
>  	list_del(&hdev->list);
>  	write_unlock_bh(&hci_dev_list_lock);
> @@ -914,6 +912,8 @@ int hci_unregister_dev(struct hci_dev *h
>  
>  	hci_notify(hdev, HCI_DEV_UNREG);
>  
> +	hci_unregister_sysfs(hdev);
> +
>  	__hci_dev_put(hdev);
>  
>  	return 0;
-- 
Stefan Seyfried
R&D Team Mobile Devices            |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg | "Well, surrounding them's out."

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
