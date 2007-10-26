Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbXJZHQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbXJZHQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763551AbXJZHBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:01:15 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37116 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760849AbXJZHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:01:11 -0400
Date: Fri, 26 Oct 2007 09:01:10 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [BUG] panic after umount (biscted)
Message-ID: <20071026070110.GA8927@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After umount of 
/dev/md/1 on /mnt/sec type xfs (rw,nosuid,nodev,noatime,nodiratime)

I end up with [1] on v2.6.24-rc1. It worked fine with v2.6.23. Bisec
came to conclusion that 

|fd5d806266935179deda1502101624832eacd01f is first bad commit
|commit fd5d806266935179deda1502101624832eacd01f
|Author: Jens Axboe <jens.axboe@oracle.com>
|Date:   Tue Oct 16 11:05:02 2007 +0200
|
|    block: convert blkdev_issue_flush() to use empty barriers
|    
|    Then we can get rid of ->issue_flush_fn() and all the driver private
|    implementations of that.
|    
|    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
|
|:040000 040000 75f5c511fd785fa4c75b955f1818c382593a22ec adf460e288740ca9c0b5ab823dfc2ca04980f3d2 M      block
|:040000 040000 a972fe9a2433a00c79fd5ead584c482cd08b4b2c 0f4534094b63fe21c5cf8a6170736abe5c518c00 M      drivers
|:040000 040000 ba2a9f681826db89ba5192a7db7139baecde786a fc68a77a41d25c283f39f712216566e9b36d00fc M      include

is the bad boy here.
The last panic (with first bad commit) is [2] (there is almost no 
difference). My .config [3], lspci [4], bisec-log [5]. The md1 
raid is a

|Personalities : [raid1] 
|md1 : active raid1 sda2[1]
|      174843328 blocks [2/1] [_U]
|

I hope this was usefull. Now, I'm going to rebuild my raid now....

[1] http://download.breakpoint.cc/bug/bug_rc1.jpeg 166 KiB
[2] http://download.breakpoint.cc/bug/bug_last_commit.jpeg 217 KiB
[3] http://download.breakpoint.cc/bug/config.txt 27 KiB
[4] http://download.breakpoint.cc/bug/lspci.txt 2.3 KiB
[5] http://download.breakpoint.cc/bug/git-bisect-log.txt 2.3K

Sebastian
