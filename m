Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYCaT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYCaT5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYCaT5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:57:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:51270 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbYCaT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iciD+qK3KJI1tmRMmAt4d6oiz2QvSPib/4gjBgzow7J97Odlnp7U9fLZoUBajcT5X0zHV/1s1APcVW3s6EvDiXyPr2L0o11RSF/ivydlDLIMxeInIwC93Ndla5fkJFd3Ao10/CaPCPFmChvuHaVaoNouf4rxgfm+KZ7xbHsAZc4=
Message-ID: <38d465440803311257r38a85f52ued9e92d7ac0ec8c8@mail.gmail.com>
Date: Mon, 31 Mar 2008 16:57:06 -0300
From: "=?ISO-8859-1?Q?Dami=E1n_Gatabria?=" <dgatabria@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: /proc/scsi/sg/debug and timeouts
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a question regarding the values reported by
/proc/scsi/sg/debug. I'm currently troubleshooting a SCSI tape problem
-- our backup software sometimes gets stuck and never releases the
drive. I see some messages in dmesg about reservation conflicts, which
leads me to believe that some other process is trying to grab the
drive when it's busy doing something else...?

Assuming this theory is correct, I cat /proc/scsi/sg/debug and find this:

 sg]# cat debug
dev_max(currently)=64 max_active_device=61 (origin 1)
 def_reserved_size=65536
 >>> device=sg56 scsi1 chan=0 id=0 lun=2   em=0 sg_tablesize=255 excl=0
   FD(1): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=324 t_o/elap=1800000/86235844ms sgat=0 op=0x4d
   FD(2): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=324 t_o/elap=1800000/59911955ms sgat=0 op=0x4d
   FD(3): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=324 t_o/elap=1800000/23683541ms sgat=0 op=0x4d
   FD(4): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     act: id=0 blen=0 t_o/elap=1800000/21087406ms sgat=0 op=0x16
   FD(5): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=324 t_o/elap=1800000/15882555ms sgat=0 op=0x4d
   FD(6): timeout=1800000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=324 t_o/elap=1800000/4728576ms sgat=0 op=0x4d
   FD(7): timeout=600000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=96 t_o/elap=600000/3465563ms sgat=0 op=0x12
   FD(8): timeout=60000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=36 t_o/elap=20000/2543704ms sgat=0 op=0x12
     act: id=0 blen=36 t_o/elap=20000/2518259ms sgat=0 op=0x12
   FD(9): timeout=60000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=36 t_o/elap=60000/1605323ms sgat=0 op=0x12
   FD(10): timeout=600000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=96 t_o/elap=600000/1574035ms sgat=0 op=0x12
   FD(11): timeout=60000ms bufflen=65536 (res)sgat=2 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=1
     rb>> act: id=0 blen=36 t_o/elap=60000/1548383ms sgat=0 op=0x12


So, I see that of all of those commands, only '6' corresponds to an
open file descriptor (the backup process, which is sleeping, waiting
for a read on the tape drive's sg device to return), and I also see
that '4' is a closed file descriptor with an active "0x16 RESERVE".
However, several of these
show 'elapsed' times that go beyond their respective timeout values.

I'm running: Red Hat Enterprise Linux AS release 4 (Nahant Update 6)
Kernel: 2.6.9-67.ELsmp


Questions:
 - Aren't the commands that are beyond their timeouts supposed to
expire somehow?
 - Is there a way for me to get some information about which process
created '4'?

Thank you,

Damian
