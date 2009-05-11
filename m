Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZEKHF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZEKHF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZEKHFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:05:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZEKHFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:05:48 -0400
Message-ID: <4A07CE86.5090301@cn.fujitsu.com>
Date: Mon, 11 May 2009 15:06:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-btrace <linux-btrace@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] blktrace: from-sector redundant in trace_block_remap, fix
References: <49FF4FAE.3000301@hp.com> <49FF517C.7000503@hp.com>
In-Reply-To: <49FF517C.7000503@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Removed redundant from-sector parameter: it's /always/ the bio's sector
> passed in.
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

I reviewed the older version of this patch, but didn't review it again when
Alan sent out this revised one, and I just found a typo in it...

> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
...
>  DECLARE_TRACE(block_remap,
>  	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
> -		 sector_t to, sector_t from),
> -	      TP_ARGS(q, bio, dev, to, from));
> +		 sector_t to),
> +	      TP_ARGS(q, bio, dev, to));

It should be 'from', not 'to'.


==============


From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] blktrace: from-sector redundant in trace_block_remap, fix

The last argument of block_remap prober is the original sector
before remap, so it should be 'from', not 'to'.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/block.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/block.h b/include/trace/block.h
index 8ac945b..5b12efa 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
 
 DECLARE_TRACE(block_remap,
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t to),
-	      TP_ARGS(q, bio, dev, to));
+		 sector_t from),
+	      TP_ARGS(q, bio, dev, from));
 
 #endif
-- 
1.5.4.rc3



