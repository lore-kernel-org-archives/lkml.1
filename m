Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbXK0DvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbXK0DvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXK0DvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:51:12 -0500
Received: from bay0-omc3-s28.bay0.hotmail.com ([65.54.246.228]:55085 "EHLO
	bay0-omc3-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbXK0DvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:51:11 -0500
Message-ID: <BLU103-DAV17D83CDEA333FB9BC87580D6760@phx.gbl>
X-Originating-IP: [130.13.252.143]
X-Originating-Email: [joshin@hotmail.com]
From: "Josh Goldsmith" <joshin@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Date: Mon, 26 Nov 2007 20:50:54 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-OriginalArrivalTime: 27 Nov 2007 03:51:10.0652 (UTC) FILETIME=[BF8F07C0:01C830A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>When you untar, which filesystem do you untar too?
I've untarred it to Ext3, Ext2, and Reiser filesystems.  I've been fighting
with this for a while.

I did manage to get it to happen again doing a recursive chmod after
untarring the kernel (I stopped the untar a few times to let the system
catch up).

Interesting output below.

-J

top - 17:58:03 up  3:08,  1 user,  load average: 3.54, 4.09, 4.08
Tasks:  53 total,   2 running,  51 sleeping,   0 stopped,   0 zombie
Cpu(s):  2.1%us, 11.4%sy,  0.6%ni,  0.0%id, 81.4%wa,  2.7%hi,  1.8%si,
0.0%st
Mem:     30352k total,    28252k used,     2100k free,    19448k buffers
Swap:   465876k total,    15736k used,   450140k free,     1072k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 1357 root      30  15  1568  168   88 R  8.1  0.6   0:07.87 chmod
  168 root      10  -5     0    0    0 S  3.1  0.0   6:39.25 usb-storage
 1353 root      15   0  2408  540  400 R  2.2  1.8   0:14.29 top
  989 root      15   0  3600  292  192 S  1.2  1.0   0:37.81 sshd
    2 root      34  19     0    0    0 S  0.6  0.0   2:14.65 ksoftirqd/0
   56 root      15   0     0    0    0 S  0.3  0.0   0:23.85 pdflush
   58 root      10  -5     0    0    0 S  0.3  0.0   0:54.70 kswapd0
  950 root      15   0  3128  108   64 S  0.3  0.4   0:13.88 ntpd
    1 root      16   0  1440    0    0 S  0.0  0.0   0:10.40 init
    3 root      10  -5     0    0    0 S  0.0  0.0   0:00.02 events/0
    4 root      10  -5     0    0    0 S  0.0  0.0   0:00.02 khelper
    5 root      10  -5     0    0    0 S  0.0  0.0   0:00.00 kthread
   38 root      10  -5     0    0    0 S  0.0  0.0   0:00.04 kblockd/0
   41 root      10  -5     0    0    0 S  0.0  0.0   0:00.02 khubd
   57 root      15   0     0    0    0 D  0.0  0.0   0:20.29 pdflush


And the first of the oom-killer syslog messages:

ntpd invoked oom-killer: gfp_mask=0x200d2, order=0, oomkilladj=0
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:
0
sshd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
Active:2816 inactive:2778 dirty:0 writeback:0 unstable:0
 free:179 slab:858 mapped:1 pagetables:93 bounce:0 

