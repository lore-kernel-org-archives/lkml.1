Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZGOSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZGOSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZGOSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:36:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48180 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbZGOSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gff3Vc60lGDIbQRiDychb9YVk2oPYJotwINw87FmFV+kIhtMXg/+qt7P7d/Q0mBhai
         ShBVHHw250LcVkpSAuxrUJiJYy3WtfIVp/Wi24JN/BQzkJ/aJxeHUowaugaCd/VSflcv
         7jjVTn+Jp5UdytHN8Yd7KyyxpjM0I/jGcvfVA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 15 (bdi warning)
Date: Wed, 15 Jul 2009 20:41:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090715-03649-g2a49c7b; KDE/4.2.4; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <20090715161841.9be17451.sfr@canb.auug.org.au>
In-Reply-To: <20090715161841.9be17451.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907152041.08025.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 July 2009 08:18:41 Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090714:

Jens, I see the following warning sometimes during disconnect
of usb-storage device, is this anything to be worried about?

------------[ cut here ]------------
WARNING: at mm/backing-dev.c:787 bdi_destroy+0x1e/0x4d()
Hardware name: Extensa 2900
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage radeon sco bnep l2cap bluetooth rfkill lib80211_crypt_tkip xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 acerhk binfmt_misc uinput snd_intel8x0m snd_intel8x0 snd_ac97_codec ipw2200 ac97_bus snd_pcm snd_timer libipw snd soundcore uhci_hcd ehci_hcd parport_pc snd_page_alloc lib80211 parport [last unloaded: scsi_wait_scan]
Pid: 183, comm: khubd Tainted: G   M       2.6.31-rc3-next-20090715-03649-g2a49c7b #23
Call Trace:
 [<c0129db9>] warn_slowpath_common+0x65/0x7c
 [<c01705c7>] ? bdi_destroy+0x1e/0x4d
 [<c0129ddd>] warn_slowpath_null+0xd/0x10
 [<c01705c7>] bdi_destroy+0x1e/0x4d
 [<c0229d3d>] blk_release_queue+0x38/0x47
 [<c0233f10>] kobject_release+0x3f/0x4f
 [<c0233ed1>] ? kobject_release+0x0/0x4f
 [<c02349c1>] kref_put+0x39/0x42
 [<c0233e4d>] kobject_put+0x37/0x3c
 [<c02285cb>] blk_put_queue+0xd/0xf
 [<c0228747>] blk_cleanup_queue+0x3d/0x41
 [<c02b9713>] scsi_free_queue+0x8/0xa
 [<c02bd0f9>] scsi_device_dev_release_usercontext+0xf6/0x12c
 [<c02bd003>] ? scsi_device_dev_release_usercontext+0x0/0x12c
 [<c0137c3c>] execute_in_process_context+0x1d/0x5b
 [<c02bd001>] scsi_device_dev_release+0x13/0x15
 [<c02ae690>] device_release+0x35/0x5a
 [<c0233f10>] kobject_release+0x3f/0x4f
 [<c0233ed1>] ? kobject_release+0x0/0x4f
 [<c02349c1>] kref_put+0x39/0x42
 [<c0233e4d>] kobject_put+0x37/0x3c
 [<c02ae459>] put_device+0xf/0x11
 [<c02bd3df>] __scsi_remove_device+0x61/0x65
 [<c02bb3a8>] scsi_forget_host+0x35/0x51
 [<c02b6544>] scsi_remove_host+0x69/0xcd
 [<e0833684>] quiesce_and_remove_host+0x4c/0x7e [usb_storage]
 [<e083376a>] usb_stor_disconnect+0x13/0x1d [usb_storage]
 [<c02e039f>] usb_unbind_interface+0x3b/0xa0
 [<c02b0c84>] __device_release_driver+0x47/0x7f
 [<c02b0d59>] device_release_driver+0x18/0x23
 [<c02b04bb>] bus_remove_device+0x7f/0x8c
 [<c02af04a>] device_del+0xf0/0x127
 [<c02de6a3>] usb_disable_device+0x61/0xbf
 [<c02dab52>] usb_disconnect+0x7e/0xda
 [<c02db666>] hub_thread+0x30f/0xad5
 [<c013a52d>] ? autoremove_wake_function+0x0/0x2f
 [<c011eca9>] ? complete+0x34/0x3e
 [<c02db357>] ? hub_thread+0x0/0xad5
 [<c013a2f3>] kthread+0x66/0x6b
 [<c013a28d>] ? kthread+0x0/0x6b
 [<c01034eb>] kernel_thread_helper+0x7/0x10
---[ end trace d1600192f6c800d2 ]---
