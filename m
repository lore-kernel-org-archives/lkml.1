Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYDVHla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYDVHla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYDVHlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:41:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:10909 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbYDVHlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=OOJn0bA2Ry02Tb/pJ/k8JY8I9ZF14/Jp42NjLW6wfBdjecuxF/XWuP7dbmqV2lO8yTv+ujnOmHUpvnMoEZwnQA4QzzJ1sZx5W70wGB9auls17HwH611ZnJI4FkL4mU1ADDFXgNLudwjYy+rduLogzoSN8Z55R8cM3f7k5wtDlrM=
Date: Tue, 22 Apr 2008 09:40:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [2.6.25] BUG: soft lockup - CPU#0 stuck for 61s! [fuser:15920]
Message-ID: <20080422074026.GA6137@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Yesterday I left my box to finish some compilation with "; shutdown -h +5" appended
and in the morning I was suprised by:
(partially transcribed from photos)

BUG: soft lockup - CPU#0 stuck for 61s! [fuser:15920]
CPU 0:
Modules linked in: udf vfat fat usb_storage af_packet ac97_bus soundcore usbhid uhci_hcd ehci_hcd usbcore tuner tea5767 tda8290 tuner_xc2028
tda9887 tuner_simple mt20xx tea5761 tda9875 bttv firmware_class ir_common compat_ioctl32 i2c_viapro videodev v4l1_compat v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom [last unloaded: snd_page_alloc]
Pid: 15920, comm: fuser Tainted: G      D  2.6.25 #213
RIP: 0010:[<ffffffff0036ad14>]  [<ffffffff0036ad14>] _raw_spin_lock+0xb4/0x130
RSP: 0010:ffff01003e019e50 EFLAGS: 00000216
RAX: 0000000000000000 RBX: ffff01003e019e70 RCX: 0000000000000000
(...)

Call Trace:
? _raw_spin_lock+0xcb/0x130
? _spin_lock+0x37/0x40
? new_inode+0x30/0xc0
? sock_alloc+0x19/0x90
? __sock_create+0x03/0x320
? sock_create+0x2d/0x30
? sys_socket+0x12/0x40
? system_call_after_swapgs+0x7b/0x00





SysRq : Show Blocked State
(...)
runnable tasks:
           init
     watchdog/0
       events/0
    cifsoplockd
   cifsdnotifyd
      kjournald
        pdflush
        pdflush
        halt.sh
R         fuser

config, normal dmesg and photos can be found at:
http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.04.22-2.6.25-softlockup/
unfortunately photos have poor quality :|

Cheers,
Marcin
