Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYIKSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYIKSdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYIKSdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:33:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYIKSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:33:01 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Thu, 11 Sep 2008 20:01:16 +0200
To: linux-kernel@vger.kernel.org
From: Harun Scheutzow <harun04@scheutzow.de>
Subject: vfat file system extreme fragmentation on multiprocessor
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
X-Provags-ID: V01U2FsdGVkX18U29VLcUqtVHhJos9TEMySqNs4ItKLi06kQrg
 SnG0OFtRgFlzjzdxT+pASybxEo0xAItPfj7J+FjR9ipf9XlKEs
 6IdpYZrzHfVLtHknV9rjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like to share the following observation made with different kernels of 2.6.x series, a T7100 Core2Duo CPU (effectively 2 processors). I have not seen such a post while searching.

Two applications compress data at the same time and try to do their best to avoid fragmenting the file system by writing blocks of 50 MByte to a VFAT (FAT32) partition on SATA harddisk, cluster size 8 KByte. Resulting file size is 200 to 250 MByte. It is ok to get 4 to 5 fragments per file. But at random, approximately at every 4th file, there are a few 100 up to more than 4500 (most likely case approx 1500) fragments for each of the two files written in parallel.

My best guess: In this case both CPU cores were in the cluster allocation function of the fat file system at (nearly) the same time, allocating only a few clusters (guess 8) for their file before the other core got the next. The compression task is CPU bound. The harddisk could probably cater 4 cores. This reverses for decompression.

The files are ok, no corruption, just heavy fragmentation. I know vfat is not liked very much. Nevertheless I like to hope someone with more Linux kernel coding experience than me fixes this in the future.

vfat still seems to be the reliable way for data exchange accross platforms (anyone an ext2 driver for Win up to Vista which does not trash the f.s. every few days, or a reliable NTFS for Linux?). Anyway, it is a general design issue on SMP systems one should not forget.

I tried the same to an ext2 f.s.. It showed only very little fragmentation, most files were 1 piece, well done!

Best Regards, Harun Scheutzow

