Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXFUBkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXFUBkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 21:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXFUBki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 21:40:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:51568 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXFUBkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 21:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DSMDYQnqpqguOI89YiLZBBJjtUuqTuM0gZbAVgTGLfS3svwpkayrkhkzcifiaEB0atQIbDGBdCs9CByI8dMG6rmFEBFbEc8noHJ65MeQeQ9tRoQKBATJu/mDLSZ/wZBx1D1LMTw1ipalaZ6LmD8WppSb/KXYVUELzq3i7W03uVI=
Message-ID: <3d0408630706201840o5b1c2454n75d1ebbd26d660d6@mail.gmail.com>
Date: Thu, 21 Jun 2007 09:40:35 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?]Set XIP mount option on ext2 bypass check.
In-Reply-To: <4679A58C.2080008@21cn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4679A58C.2080008@21cn.com>
X-Google-Sender-Auth: d3c654a864b23179
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I mount an ext2 fs , then remount it with xip option set.
I get message below when do write operation in the fs.

--------
kernel BUG at fs/ext2/xip.c:21!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/eth0/carrier
Modules linked in: ext2 autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 dm_mirro
r dm_multipath video sbs i2c_ec button dock battery ac lp floppy snd_ens1371 gam
eport snd_rawmidi snd_ac97_codec pcnet32 ac97_bus snd_seq_dummy snd_seq_oss snd_
seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_time
r snd soundcore snd_page_alloc mii serio_raw parport_pc parport pcspkr BusLogic
i2c_piix4 i2c_core sg ext3 jbd mbcache squashfs dm_snapshot dm_mod loop sd_mod e
hci_hcd uhci_hcd ata_piix ata_generic libata sr_mod scsi_mod cdrom
CPU:    0
EIP:    0060:[<d8cba143>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-1.3194.fc7 #1)
EIP is at ext2_clear_xip_target+0x1e/0x47 [ext2]
eax: d887da00   ebx: d310e3c0   ecx: d0648bd4   edx: 00001e01
esi: d0648b4c   edi: 00000000   ebp: cc863e44   esp: cc863df8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process dd (pid: 3231, ti=cc863000 task=cd61b710 task.ti=cc863000)
Stack: 000000d8 ffffff10 00000200 00001e01 d8cb5b5b cc863e44 cc863e8c 00000c9f
       cd61b710 00000001 d0648bd4 00000000 cc863e50 00000001 00000001 00000400
       cc863e74 cc863e50 c043c220 d0648b4c 00001e01 00000000 00000f8c 00000e34
Call Trace:
 [<d8cb5b5b>] ext2_get_block+0x3f4/0x52b [ext2]
 [<c043c220>] clockevents_program_event+0xb2/0xb9
 [<c04bed36>] avc_has_perm+0x4e/0x58
 [<d8cba05d>] ext2_get_xip_page+0x65/0xde [ext2]
 [<c0473972>] xip_file_write+0x232/0x38d
 [<c0473740>] xip_file_write+0x0/0x38d
 [<c0475d33>] vfs_write+0xa8/0x154
 [<c0476342>] sys_write+0x41/0x67
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
Code: 89 0c 24 e8 88 cd ff ff 83 c4 0c 5b c3 57 53 83 ec 08 8b 80 9c 00 00 00 8b
 98 98 00 00 00 8b 43 5c 8b 40 34 8b 78 14 85 ff 75 04 <0f> 0b eb fe 8d 44 24 04
 31 c9 c1 e2 03 89 04 24 89 d8 ff d7 85
EIP: [<d8cba143>] ext2_clear_xip_target+0x1e/0x47 [ext2] SS:ESP 0068:cc863df8
