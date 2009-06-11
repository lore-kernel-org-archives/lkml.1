Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbZFKMyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbZFKMyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZFKMxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:53:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZFKMxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:53:52 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>
	<20090611110903.GO11363@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 11 Jun 2009 08:53:42 -0400
In-Reply-To: <20090611110903.GO11363@kernel.dk> (Jens Axboe's message of "Thu,
	11 Jun 2009 13:09:03 +0200")
Message-ID: <x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Jun 11 2009, Kiyoshi Ueda wrote:
>> Hi Jens,
>> 
>> This patch adds the following 2 interfaces for request-stacking drivers:
>> 
>>   - blk_rq_prep_clone(struct request *clone, struct request *orig,
>> 		      struct bio_set *bs, gfp_t gfp_mask,
>> 		      int (*bio_ctr)(struct bio *, struct bio*, void *),
>> 		      void *data)
>>       * Clones bios in the original request to the clone request
>>         (bio_ctr is called for each cloned bios.)
>>       * Copies attributes of the original request to the clone request.
>>         The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not
>>         copied.
>> 
>>   - blk_rq_unprep_clone(struct request *clone)
>>       * Frees cloned bios from the clone request.
>> 
>> Request stacking drivers (e.g. request-based dm) need to make a clone
>> request for a submitted request and dispatch it to other devices.
>> 
>> To allocate request for the clone, request stacking drivers may not
>> be able to use blk_get_request() because the allocation may be done
>> in an irq-disabled context.
>> So blk_rq_prep_clone() takes a request allocated by the caller
>> as an argument.
>> 
>> For each clone bio in the clone request, request stacking drivers
>> should be able to set up their own completion handler.
>> So blk_rq_prep_clone() takes a callback function which is called
>> for each clone bio, and a pointer for private data which is passed
>> to the callback.
>> 
>> NOTE:
>> blk_rq_prep_clone() doesn't copy any actual data of the original
>> request.  Pages are shared between original bios and cloned bios.
>> So caller must not complete the original request before the clone
>> request.
>
> This looks good to me now, I've applied it.

Is blk_rq_unprep_clone really the best name?
          ^^^^^^

Cheers,
Jeff
