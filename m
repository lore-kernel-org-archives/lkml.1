Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbZFQNDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbZFQNDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbZFQND3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:03:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbZFQND3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:03:29 -0400
Date: Wed, 17 Jun 2009 09:00:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use of flat
	elevator fair queuing
Message-ID: <20090617130000.GB15473@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-5-git-send-email-vgoyal@redhat.com> <4A385374.7060708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A385374.7060708@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 10:22:44AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > This patch changes cfq to use fair queuing code from elevator layer.
> > 
> 
> elevator_private2 isn't used to store cfqq now.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Queued up for next posting.

Vivek

> ---
>  block/cfq-iosched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 23b24b9..7a9bbe6 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1874,7 +1874,7 @@ static void cfq_put_request(struct request *rq)
>  		put_io_context(RQ_CIC(rq)->ioc);
>  
>  		rq->elevator_private = NULL;
> -		rq->elevator_private2 = NULL;
> +		rq->ioq = NULL;
>  
>  		cfq_put_queue(cfqq);
>  	}
> -- 
> 1.5.4.rc3
