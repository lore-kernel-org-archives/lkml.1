Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZFLNgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZFLNgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765417AbZFLNaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:30:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36177 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765416AbZFLNaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:12 -0400
Date: Fri, 12 Jun 2009 15:30:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
	(v2)
Message-ID: <20090612133014.GK11363@kernel.dk>
References: <4A3075B2.9040208@ct.jp.nec.com> <20090611110903.GO11363@kernel.dk> <x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Thu, Jun 11 2009, Kiyoshi Ueda wrote:
> >> Hi Jens,
> >> 
> >> This patch adds the following 2 interfaces for request-stacking drivers:
> >> 
> >>   - blk_rq_prep_clone(struct request *clone, struct request *orig,
> >> 		      struct bio_set *bs, gfp_t gfp_mask,
> >> 		      int (*bio_ctr)(struct bio *, struct bio*, void *),
> >> 		      void *data)
> >>       * Clones bios in the original request to the clone request
> >>         (bio_ctr is called for each cloned bios.)
> >>       * Copies attributes of the original request to the clone request.
> >>         The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not
> >>         copied.
> >> 
> >>   - blk_rq_unprep_clone(struct request *clone)
> >>       * Frees cloned bios from the clone request.
> >> 
> >> Request stacking drivers (e.g. request-based dm) need to make a clone
> >> request for a submitted request and dispatch it to other devices.
> >> 
> >> To allocate request for the clone, request stacking drivers may not
> >> be able to use blk_get_request() because the allocation may be done
> >> in an irq-disabled context.
> >> So blk_rq_prep_clone() takes a request allocated by the caller
> >> as an argument.
> >> 
> >> For each clone bio in the clone request, request stacking drivers
> >> should be able to set up their own completion handler.
> >> So blk_rq_prep_clone() takes a callback function which is called
> >> for each clone bio, and a pointer for private data which is passed
> >> to the callback.
> >> 
> >> NOTE:
> >> blk_rq_prep_clone() doesn't copy any actual data of the original
> >> request.  Pages are shared between original bios and cloned bios.
> >> So caller must not complete the original request before the clone
> >> request.
> >
> > This looks good to me now, I've applied it.
> 
> Is blk_rq_unprep_clone really the best name?
>           ^^^^^^

Probably not, but I'm not very good at coming up with elegant names.
Your email should have included a new suggestion :-)

FWIW, I don't think the name is THAT bad...

-- 
Jens Axboe

