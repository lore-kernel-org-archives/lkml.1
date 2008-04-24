Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYDXA7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYDXA7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYDXA7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:59:34 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17675 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYDXA7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:59:34 -0400
Message-ID: <480FDB72.4030005@hp.com>
Date: Wed, 23 Apr 2008 20:59:30 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 3/3] Do not use rqhash when merges disabled
References: <480F8936.5030406@hp.com> <480F8AB9.2050805@hp.com> <480FD648.70404@gelato.unsw.edu.au>
In-Reply-To: <480FD648.70404@gelato.unsw.edu.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Carroll wrote:
> Hi Alan,
> 
> Alan D. Brunelle wrote:
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -313,7 +313,7 @@ static inline void __elv_rqhash_del(struct request
>> *rq)
>>  
>>  static void elv_rqhash_del(struct request_queue *q, struct request *rq)
>>  {
>> -    if (ELV_ON_HASH(rq))
>> +    if (!blk_queue_nomerges(q) && ELV_ON_HASH(rq))
>>          __elv_rqhash_del(rq);
>>  }
> 
> If you switch the nomerges tunable while requests are in flight, it is
> possible that
> a request is put into the rqhash table but not removed here, leading to
> the BUG_ON
> in elv_dequeue_request() triggering.  ELV_ON_HASH needs to be checked
> regardless of
> the nomerges state.
> 
> 
> -- Aaron
> 
> 

Hi Aaron -

Good catch - that was a last minute addition, the ELV_ON_HASH should be
sufficient without the check for blk_queue_nomerges, right?

Alan
