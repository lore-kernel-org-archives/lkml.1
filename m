Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYI1Wye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYI1Wye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 18:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYI1WyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 18:54:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:61537 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYI1WyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 18:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=r+15yY8jPJg0kR/hc424O44EYQIDE2d2V+pyWP/gUs+7pA2qQXAgKF8rdQH0K7+TAv
         chuK3rHdIpBrJvA3EoYyhSWOqqYvoLiIqCvDHzLYrmIuG4FOK2P2LD5YKNrpXvAs3kOG
         EaMRTzDX3iSCBmRbOhhkNFugKfdOjSHGB1zPU=
Message-ID: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
Date: Sun, 28 Sep 2008 15:54:23 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG kmalloc-16: Object already free
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After frying my system, I'm finally up and
running. Not sure if this was due to a git-pull
(only be a few days since the last pull), or what:
when waking from suspend I see this
(I know it says tainted in it, so this will be the only noise you'll
here from me on this);

[  274.327003] =============================================================================
[  274.327528] BUG kmalloc-16: Object already free
[  274.327877] -----------------------------------------------------------------------------
[  274.327879]
[  274.327890] INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=0
cpu=1 pid=3763
[  274.327899] INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=0
cpu=1 pid=3763
[  274.327905] INFO: Slab 0xc139a100 objects=64 used=62 fp=0xdcd08100
flags=0x400000c3
[  274.327909] INFO: Object 0xdcd08100 @offset=256 fp=0xdcd08140
[  274.327912]
[  274.327914] Bytes b4 0xdcd080f0:  32 0d 00 00 c8 ba ff ff 5a 5a 5a
5a 5a 5a 5a 5a 2...ÈºÿÿZZZZZZZZ
[  274.327928]   Object 0xdcd08100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[  274.327940]  Redzone 0xdcd08110:  bb bb bb bb
              »»»»
[  274.327952]  Padding 0xdcd08138:  5a 5a 5a 5a 5a 5a 5a 5a
              ZZZZZZZZ
[  274.327966] Pid: 3763, comm: hcid Tainted: P
2.6.27-rc7-00106-g6ef190c #34
[  274.327973]  [<c0170107>] print_trailer+0xc8/0xd0
[  274.327982]  [<c01701c3>] object_err+0x25/0x30
[  274.327989]  [<c0170a0a>] __slab_free+0x1be/0x271
[  274.327995]  [<c0170a85>] ? __slab_free+0x239/0x271
[  274.328001]  [<c0171147>] kfree+0x9c/0xb2
[  274.328006]  [<c02ca1d6>] ? urb_destroy+0x14/0x1e
[  274.328013]  [<c02ca1d6>] ? urb_destroy+0x14/0x1e
[  274.328018]  [<c02ca1c2>] ? urb_destroy+0x0/0x1e
[  274.328024]  [<c02ca1d6>] urb_destroy+0x14/0x1e
[  274.328028]  [<c02133b9>] kref_put+0x39/0x44
[  274.328035]  [<c02ca1c0>] usb_free_urb+0x11/0x13
[  274.328040]  [<f8db69b7>] btusb_open+0x147/0x16f [btusb]
[  274.328049]  [<f8d88abb>] hci_dev_open+0x50/0x168 [bluetooth]
[  274.328077]  [<f8d8cf01>] hci_sock_ioctl+0xd4/0x20e [bluetooth]
[  274.328094]  [<c0307dc9>] sock_ioctl+0x1b4/0x1d8
[  274.328101]  [<c0307c15>] ? sock_ioctl+0x0/0x1d8
[  274.328107]  [<c017e542>] vfs_ioctl+0x22/0x67
[  274.328113]  [<c017e7cc>] do_vfs_ioctl+0x245/0x253
[  274.328118]  [<c01f45ae>] ? selinux_file_ioctl+0x37/0x3a
[  274.328125]  [<c017e81a>] sys_ioctl+0x40/0x5a
[  274.328130]  [<c010301f>] sysenter_do_call+0x12/0x2f
[  274.328137]  =======================
[  274.328141] FIX kmalloc-16: Object at 0xdcd08100 not freed


If anybody needs the full dmesg let me know
regards;
-- 
Justin P. Mattock
