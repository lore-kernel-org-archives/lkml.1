Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZGRHAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZGRHAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932317AbZGRHAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:00:09 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:35451 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbZGRHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:00:08 -0400
Message-ID: <4A6172F0.60707@davidnewall.com>
Date: Sat, 18 Jul 2009 16:30:00 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Regression impacts ServeRAID II on IBM xSeries 5500
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fujita-san,

This is my first time reporting a regression.  I hope I'm doing it right.

According to "git bisect," your patch
10db10d144c0248f285242f79daf6b9de6b00a62 is the first bad commit before
a regression which affects my ServeRAID II controller.  I get segfault
running ipssend, which is the program used to interrogate and configure
the SCSI RAID controller.

    ipssend[5949]: segfault at 20202020 ip b7ece8b1 sp bfce1d1c error 6 in libc-2.9.so[b7e55000+15c000]
      

Here's what git output on the final bisect:

    commit 10db10d144c0248f285242f79daf6b9de6b00a62
    Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Date:   Fri Aug 29 12:32:18 2008 +0200

        sg: convert the indirect IO path to use the block layer
        
        This patch converts the indirect IO path (including mmap IO and old
        struct sg_header) to use the block layer functions (blk_get_request,
        blk_execute_rq_nowait, blk_rq_map_user, etc) instead of
        scsi_execute_async().
        
        [Jens: fixed compile error with SCSI logging enabled]
        
        Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
        Signed-off-by: Douglas Gilbert <dougg@torque.net>
        Cc: Mike Christie <michaelc@cs.wisc.edu>
        Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
        Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

    :040000 040000 a2b5d80fb0a666b49d4bdfc2de3aa15c9d8b1ec7 84a927a0964a616313deb410a1da60dd22e2dc13 M    drivers
      

My machine and assistance is at your disposal.  Rather than guess what
information you want: what can I tell you?

Regards,

David
