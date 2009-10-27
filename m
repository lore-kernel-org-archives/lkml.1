Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZJ0OXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZJ0OXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZJ0OXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:23:13 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34404 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZJ0OXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MakWLq/dFo/QgqCTKufUAkJk+TybbVmzM/2FfoBhx1VL+ED2gl6SGJr7i3rYujBq5a
         gnAr/cLR3tug1CbxmQW5Cq443K3Ubwy2CTl1caRDNfXorYuScmy9YwCTxdv2RJnnY3HO
         aBnj2+VbSBklRI4fFCFG92rAVXjwlwm+a7ABw=
MIME-Version: 1.0
In-Reply-To: <3a665c760910270627u784d43b8t2978731110c920a4@mail.gmail.com>
References: <3a665c760910270627u784d43b8t2978731110c920a4@mail.gmail.com>
Date: Tue, 27 Oct 2009 22:23:17 +0800
Message-ID: <3a665c760910270723l6989539er7e820d630cce51ac@mail.gmail.com>
Subject: kernel panic about kernel unaligned access
From: loody <miloody@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:
I use kernel 2.6.18 and I get the kernel panic as below:
Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 00000000 11000001 0000040a 8721f0d8
$ 4   : 874a6c00 80001d18 00000000 00000000
$ 8   : 00000000 ffffa438 00000000 874c2000
$12   : 00000000 00000000 00005800 00011000
$16   : 80001d10 874a6c40 874a6c00 87d7bf00
$20   : 874a6c78 871a0000 87370000 874a6c80
$24   : 00000000 2aacc770
$28   : 87d7a000 87d7be88 ffffa438 8709ed20
Hi    : 00000000
Lo    : 00000000
epc   : 8709e72c sync_sb_inodes+0x9c/0x320     Not tainted
ra    : 8709ed20 writeback_inodes+0xb4/0x160
Status: 11000003    KERNEL EXL IE
Cause : 00808010
BadVA : 00000442
PrId  : 00019654
Modules linked in:
Process pdflush (pid: 38, threadinfo=87d7a000, task=87d695b8)
Stack : ffffffff ffffffff 871c0000 87cae4d8 874a6c00 874a6c40 87d7bf00 871c4290
       87d7bf64 871a0000 87370000 00000000 00000000 8709ed20 ffffffff ffffffff
       8735e380 874bb8a8 00000400 0000034b ffffa62c 87d7bf00 87057f9c 00000000
       87189270 87188b20 00000000 87189564 ffff9880 87362d58 00000000 00000000
       87d7bef8 00000400 00000000 00000000 00000000 00000000 00000000 00000000
       ...
Call Trace:
 [<8709ed20>] writeback_inodes+0xb4/0x160
 [<87057f9c>] wb_kupdate+0xb8/0x154
 [<87189270>] __schedule+0x998/0xb34
 [<87188b20>] __schedule+0x248/0xb34
 [<87189564>] preempt_schedule+0x68/0xac
 [<87058d74>] pdflush+0x188/0x284
 [<87058cfc>] pdflush+0x110/0x284
 [<8703b9e4>] kthread+0x14c/0x1b8
 [<87057ee4>] wb_kupdate+0x0/0x154
 [<87058bec>] pdflush+0x0/0x284
 [<8703ba00>] kthread+0x168/0x1b8
 [<87003398>] kernel_thread_helper+0x10/0x18
 [<87003388>] kernel_thread_helper+0x0/0x18


Code: 8e450084  24b0fff8  8e02009c <8c510038> 8e220008  30420002
1040000f  00000000  8ca20000
note: pdflush[38] exited with preempt_count 1

my questions are:
1. what does "Not tainted" mean?
2. I grep the kernel and I find the above message comes from do_ade in
unaligned.c, If I guess correctly.
   but from the call trace I cannot find out who call it.
   who and how kernel pass the information to do_ade?
3. as far as i know, inode is the data structure we used to record file.
>From what information in the inode I can find out the file name the
writeback_inodes try to write?
4. take  [<87189564>] preempt_schedule+0x68/0xac for example, what
does "0xac" mean?
appreciate your help,
miloody
