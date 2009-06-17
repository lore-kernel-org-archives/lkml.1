Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZFQCY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZFQCY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZFQCYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:24:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZFQCYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:24:48 -0400
Message-ID: <4A385374.7060708@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 10:22:44 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use of flat elevator
 fair queuing
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1244513342-11758-5-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch changes cfq to use fair queuing code from elevator layer.
> 

elevator_private2 isn't used to store cfqq now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 23b24b9..7a9bbe6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1874,7 +1874,7 @@ static void cfq_put_request(struct request *rq)
 		put_io_context(RQ_CIC(rq)->ioc);
 
 		rq->elevator_private = NULL;
-		rq->elevator_private2 = NULL;
+		rq->ioq = NULL;
 
 		cfq_put_queue(cfqq);
 	}
-- 
1.5.4.rc3

