Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYDXAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYDXAiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYDXAiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:38:10 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:47980 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbYDXAiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:38:09 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Date: Thu, 24 Apr 2008 10:37:28 +1000
Message-ID: <480FD648.70404@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 3/3] Do not use rqhash when merges disabled
References: <480F8936.5030406@hp.com> <480F8AB9.2050805@hp.com>
In-Reply-To: <480F8AB9.2050805@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan D. Brunelle wrote:
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -313,7 +313,7 @@ static inline void __elv_rqhash_del(struct request *rq)
>  
>  static void elv_rqhash_del(struct request_queue *q, struct request *rq)
>  {
> -	if (ELV_ON_HASH(rq))
> +	if (!blk_queue_nomerges(q) && ELV_ON_HASH(rq))
>  		__elv_rqhash_del(rq);
>  }

If you switch the nomerges tunable while requests are in flight, it is possible that
a request is put into the rqhash table but not removed here, leading to the BUG_ON
in elv_dequeue_request() triggering.  ELV_ON_HASH needs to be checked regardless of
the nomerges state.


 -- Aaron

