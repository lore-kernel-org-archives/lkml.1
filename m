Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbZFWPyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbZFWPyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZFWPym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:54:42 -0400
Received: from web65313.mail.ac2.yahoo.com ([68.180.158.239]:30985 "HELO
	web65313.mail.ac2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753278AbZFWPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:54:41 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 11:54:41 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=l3L7vBmGSeh29jpHVLAJvJbQGgXNJiyGk31EPMAvrScGCPUGTV0JuQwvTqswkvzWuufr8dW1FIgx6VYBUajfO1vrUNyaQKiBAmNtO39nXPeDBKN8p1rinqy/Hg+uAxovg87h0y0AWRfcxxD9ZXjMZgehiQGoDw4uOV8Xg9/nBJk=;
Message-ID: <309427.75128.qm@web65313.mail.ac2.yahoo.com>
X-YMail-OSG: nSQRBCsVM1n97Vg5Ybfx2dv9WRbKMJ7dMtl93bwznWhLo3OvrfCEsn64htHsjgT_3l4lYW5xmMHHYpMgthIKMWLkJ2nYrQhxOhbyCA2EfH3z4Ic02SpoTve_SW1cSPwCu4BCdnuGwF0qIrZ5_tV7muljNlexZki00IKwHuCwLqp02xujvEjB4BoD5p6wuPo6zTTQaWmpmVXXQYeWnoMjkyT5cVrSueSa6fDsJvc4PBwer7IPivmOhvzyk7sXd4AipXFTBdzYnuTR_VPQIrcC4at87iM7x.kjPQ--
X-Mailer: YahooMailClassic/5.4.17 YahooMailWebService/0.7.289.15
Date: Tue, 23 Jun 2009 08:48:04 -0700 (PDT)
From: Andrew Randrianasulu <randrik_a@yahoo.com>
Subject: list_add corruption in current Linus's tree?
To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!

I'm currently using vanilla kernel form kernel.org, up to commit d888a4c76c51092993643f8992bf55b3c28da483. Since yesterday i saw many warnings like this in dmesg:

------------[ cut here ]------------
WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
Hardware name: MS-6380E
list_add corruption. next->prev should be prev (cf801454), but was c22302fc. (next=c2282c28).
Modules linked in: radeon ttm drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect sg snd_seq_dummy snd_seq_oss sd_mod snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipv6 nfsd lockd nfs_acl auth_rpcgss sunrpc usb_storage scsi_mod usb_libusual tuner_simple tuner_types ppdev tda9887 tda8290 snd_cs4236 snd_mpu401 snd_emu10k1 snd_via82xx snd_wavefront snd_ac97_codec snd_wss_lib ac97_bus snd_opl3_lib uhci_hcd saa7134 snd_mpu401_uart snd_pcm ir_common snd_rawmidi snd_timer snd_page_alloc ehci_hcd snd_util_mem videobuf_dma_sg snd_seq_device snd_hwdep videobuf_core snd parport_pc tveeprom usbcore rtc_cmos rtc_core emu10k1_gp ns558 soundcore parport floppy gameport rtc_lib shpchp 8139too pci_hotplug via_agp xfs exportfs ufs agpgart tuner v4l2_common videodev v4l1_compat w83627hf hwmon_vid hwmon i2c_viapro i2c_dev fbcon tileblit font bitblit softcursor fb
Pid: 4000, comm: X Tainted: G        W  2.6.30-i486 #17
Call Trace:
 [<c1033bd6>] warn_slowpath_common+0x65/0x95
 [<c1033c44>] warn_slowpath_fmt+0x29/0x2c
 [<c1156ebf>] __list_add+0x27/0x5c
 [<c10b9381>] mem_cgroup_add_lru_list+0x43/0x55
 [<c10975b4>] add_page_to_lru_list+0x3d/0x42
 [<c10978a1>] ____pagevec_lru_add+0xea/0x12c
 [<c1097be4>] lru_add_drain+0x3c/0x86
 [<c10a68a3>] unmap_region+0x34/0x10d
 [<c10a7629>] do_munmap+0x1df/0x235
 [<c10a76b4>] sys_munmap+0x35/0x44
 [<c1002bc5>] syscall_call+0x7/0xb
---[ end trace fda7f44fa2651cfc ]---

but many, many more. Should i create bug in kernel bugzilla, or it is known  issue?


      
