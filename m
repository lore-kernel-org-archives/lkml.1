Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXDVMiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXDVMiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030576AbXDVMiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:38:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:26691 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbXDVMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jr+xyZp6uuXvWkH/sW2HLLDWp2r2IYXLJm539fiKX2EVm30kOt6ENmNpfxvkax20bKEpwLpu6aIA1OUeOmLrmWZVf53OZ/EhvEnn3C+79thk/mvp/5W4JITuS5FjWREW2e15zz5n6c6fqCOetVeabP9c+SOnmBb0S6vAd7Q88RM=
Message-ID: <f5ba67240704220538p40f908cag39b8d7c46d87ca47@mail.gmail.com>
Date: Sun, 22 Apr 2007 13:38:13 +0100
From: "Ian Kirk" <intercede619@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG/CRASH help - 2.6.20 (fc5) - spinlock bad magic on CPU#0, kswapd
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just wondered if the below type of crash was a known thing, and if
there are any obvious things I can do to prevent/fix it ?

BUG: spinlock bad magic on CPU#0, kswapd0/242 (Not tainted)
lock: c06c9380, .magic: c06c9380, .owner:
[<c06eba2a>] _raw_spin_lock+0x1a/0xd9
[<c061e72f>] _spin_lock_irqsave+0x9/0xd
[<c041febf>] __wake_up+0x18/0x43
[<c04379ce>] __wake_up_bit+0x2e/0x33
[<c045a496>] shrink_inactive_list+0x483/0x6c9
[<c0459eae>] shrink_active_list+0x334/0x33c
[<c045a799>] shrink_zone+0xbd/0xe2
[<c045ac0e>] kswapd+0x296/0x3bb
[<c04379e9>] autoremove_wake_function+0x0/0x35
[<c045a978>] kswapd+0x0/0x3bb
[<c043792f>] kthread+0xb0/0xd9
[<c043787f>] kthread+0x0/0xd9
[<c0404b47>] kernel_thread_helper+0x7/0x10
=======================

The .owner: field contains a long list of unprintable characters.

The server is running kernel-smp-2.6.20-1.2307.fc5.i686.rpm.
Hardware of note is:

1x AMD AM2 DUALCORE 3800
2x Corsair DDR2 XMS 1Gb PC6400
2x 400G SEAGATE SATA2 ST3400633AS (traditional s/w RAID1 w/ ext3)
1x ASUS M2V-MX AM2 MOBO (onboard NIC unused)
1x e100 driver using NIC

I've a few things to try (disabling serial/par ports, unused NIC, USB).
It also crashed with a UP kernel.

Apologies if I'm duplicating any questions asked, I Googled for the
error messages but found quite different stack traces and contextx
(e.g. resiferfs vs ext3 - i'm only running ext3)

Regards,
Ian

(normally posting from blob@blob.co.uk but can't get to that as the
server is crashed!)
