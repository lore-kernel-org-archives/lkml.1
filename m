Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYHOPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYHOPM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbYHOPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:11:57 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:40106 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbYHOPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vdVP6CEUiwUoFzx72vAurZY0C8/mr3bk+LlPRRBfy4Gppq5NDK2xHjwTLtYz7E///A
         oiDeJLLTCQmPX9OoUJ7QORQjSWehTALNIY0TfCe0gm2QGH3rlMSNf3o5jBApvX9AB86H
         fHWxteXCoYUVQpExDbAYF1DAp9jJug8mIGwY4=
Message-ID: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
Date: Fri, 15 Aug 2008 17:11:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not allocated
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First the confessions: It's fedora-patched kernel, 2.6.25.11-97.fc9,
tainted by NVIDIA driver. So feel free to drop to /dev/null until I
can reproduce on a clean and recent kernel. (But -rc3 didn't boot for
me, and I don't have anything else handy atm.)

By bashing on random device nodes (with mknod + mmap as root), I got a
few messages of this kind:

idr_remove called for id=236 which is not allocated.
Pid: 3019, comm: a.out Tainted: P         2.6.25.11-97.fc9.i686 #1
 [<c04f030c>] idr_remove+0xd5/0x138
 [<c0540bfc>] release_dev+0x5bd/0x5cf
 [<c04909fd>] ? d_free+0x3b/0x4d
 [<c04955d0>] ? mntput_no_expire+0x16/0x69
 [<c048309d>] ? __fput+0x149/0x151
 [<c0540d8c>] tty_release+0x12/0x1c
 [<c0483001>] __fput+0xad/0x151
 [<c04830bc>] fput+0x17/0x19
 [<c04807df>] filp_close+0x50/0x5a
 [<c0480852>] sys_close+0x69/0xa1
 [<c0405bf2>] syscall_call+0x7/0xb
 [<c0620000>] ? agp_amd64_probe+0x134/0x3ee
 =======================

idr_remove called for id=127 which is not allocated.
Pid: 3019, comm: a.out Tainted: P         2.6.25.11-97.fc9.i686 #1
 [<c04f030c>] idr_remove+0xd5/0x138
 [<c0540bfc>] release_dev+0x5bd/0x5cf
 [<c04909fd>] ? d_free+0x3b/0x4d
 [<c04955d0>] ? mntput_no_expire+0x16/0x69
 [<c048309d>] ? __fput+0x149/0x151
 [<c0540d8c>] tty_release+0x12/0x1c
 [<c0483001>] __fput+0xad/0x151
 [<c04830bc>] fput+0x17/0x19
 [<c04807df>] filp_close+0x50/0x5a
 [<c0480852>] sys_close+0x69/0xa1
 [<c0405bf2>] syscall_call+0x7/0xb
 =======================

It looks scary. Or is it purely my own fault?

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
