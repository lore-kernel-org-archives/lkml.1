Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXEWAu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXEWAu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXEWAuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:50:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:11106 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbXEWAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BhCeCNtX7AXYH1lTTcP7GbDVXDH+XkXl2gkvwewrUSHmxFotZmINJLYyPq4Pn3Z6AIq75NZs25enDeURCJJA9ipQACRUpKSq+0/SkKDyoQIT7GveeOF0mhce5jwQFoLoSvzQBbO2QndHfuhHz9UNFwuxwt3a3wLU7bUquegvgqY=
Message-ID: <a8e1da0705221750y6f4fb251m53f3efab1f017f4@mail.gmail.com>
Date: Wed, 23 May 2007 00:50:13 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc1-mm1 cifs_mount oops
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
when I use mount -t cifs , the kernel oops, seems break at
kthread_stop, I'm not sure.

But if I add the CONFIG_CIFS_DEBUG2=y to config file, rebuild kernel,
then the oops disappeared.

Below is the oops message:

BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000008
 printing eip:
c012e910
*pde = 00000000
Oops: 0002 [#1]
PREEMPT
Modules linked in: cifs smbfs radeon drm ipv6 snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss capability commoncap e100 mii psmouse sg evdev serio_raw
snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc intel_agp
agpgart i2c_i801 pcspkr
CPU:    0
EIP:    0060:[<c012e910>]    Not tainted VLI
EFLAGS: 00210246   (2.6.22-rc1-mm1 #3)
EIP is at kthread_stop+0x10/0x90
eax: c051bde0   ebx: 00000000   ecx: c1fba000   edx: c1fef040
esi: 00000000   edi: 00000064   ebp: c2a36c80   esp: c1fbbd58
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process mount.cifs (pid: 3955, ti=c1fba000 task=c2b38540 task.ti=c1fba000)
Stack: c1fef040 ffffff90 ffffff90 f8a7a328 c285a504 f8a9a9fb 00000083 000000cf
       000000dc 0000000b c2b38540 c2af5740 c292c540 00000000 00000000 c285a4c0
       00000000 c411b400 c3a4f500 c3cec200 c1fef052 c291c1e0 c1fef037 c291c940
Call Trace:
 [<f8a7a328>] cifs_mount+0xbe8/0xf10 [cifs]
 [<c02633fe>] idr_get_new_above_int+0x3e/0x50
 [<f8a6d04e>] cifs_read_super+0x4e/0x160 [cifs]
 [<c0166fc0>] set_anon_super+0x0/0xd0
 [<f8a6d6c0>] cifs_get_sb+0x60/0xd0 [cifs]
 [<c0167491>] vfs_kern_mount+0x91/0x130
 [<c017d648>] permit_mount+0x28/0xa0
 [<c017e09a>] do_new_mount+0x8a/0x140
 [<c017e95e>] do_mount+0x25e/0x280
 [<c0440000>] schedule+0x2e0/0x680
 [<c017e602>] exact_copy_from_user+0x32/0x70
 [<c017e69a>] copy_mount_options+0x5a/0xc0
 [<c017ec19>] sys_mount+0x79/0xc0
 [<c01040bc>] syscall_call+0x7/0xb
 =======================
Code: 88 d1 d3 e0 89 43 5c 83 c4 18 5b c3 eb 0d 90 90 90 90 90 90 90
90 90 90 90 90 90 53 83 ec 08 89 c3 b8 e0 bd 51 c0 e8 90 26 31 00 <ff>
43 08 31 c9 b8 f0 c1 58 c0 89 0d ec c1 58 c0 e8 3b 01 00 00
EIP: [<c012e910>] kthread_stop+0x10/0x90 SS:ESP 0068:c1fbbd58

Regards
dave
