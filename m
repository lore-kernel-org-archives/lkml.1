Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXGQBrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXGQBrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757197AbXGQBr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:47:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbXGQBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:47:26 -0400
Message-ID: <469C1FA9.3090809@garzik.org>
Date: Mon, 16 Jul 2007 21:47:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org>
In-Reply-To: <20070716180908.e15325bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hrm.  uninitialized_var(x) does not silence the warning, on my compiler:

[jgarzik@pretzel misc-2.6]$ rpm -q gcc
gcc-4.1.2-13.fc6

@@ -1358,6 +1358,8 @@ udf_load_partition(struct super_block *sb, 
kernel_lb_addr
                         {
                                 kernel_lb_addr ino;

+ 
uninitialized_var(ino.partitionReferenceNum);
+
                                 if (!UDF_SB_LASTBLOCK(sb))

still yields

fs/udf/super.c: In function ‘udf_fill_super’:
fs/udf/super.c:1359: warning: ‘ino.partitionReferenceNum’ may be used 
uninitialized in this function


