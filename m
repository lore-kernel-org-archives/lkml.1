Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbXLQCjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbXLQCjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765835AbXLQCjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:39:42 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:33555 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765201AbXLQCjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:39:41 -0500
Message-Id: <6.0.0.20.2.20071217111426.03956ca8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Mon, 17 Dec 2007 11:38:45 +0900
To: Zach Brown <zach.brown@oracle.com>, Badari Pulavarty <pbadari@us.ibm.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] dio: falling through to buffered I/O when
  invalidationof a page fails
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4762D651.50801@oracle.com>
References: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
 <475F32B0.20107@oracle.com>
 <1197658796.12368.1.camel@dyn9047017100.beaverton.ibm.com>
 <4762D651.50801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 04:15 07/12/15, Zach Brown wrote:
 >
 >> If anyone has a testcase - I can take a look at the problem again.
 >
 >I can try and throw something together..
 >
 >- z

I did a test by using fsstress.

I modified the dio write() of fsstress to check return value, and input
following command;

# fsstress -d /root/testdir/ -l 0 -n 1000 -p 1000 -z -f creat=1 -f write=1 
-f dwrite=1

I got EIO from dio write.


I encountered some PostgreSQL mailing list archive that mentioned about 
this issue.
http://groups.google.com/group/pgsql.hackers/browse_thread/thread/c7515ccd5ac1269c/dc2ddeac3fe0d8c1?lnk=raot&fwc=1

dio can be used in PostgreSQL to write transaction log(WAL). It is said 
that when dio is used,
EIO is returned under some workload.
  

