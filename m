Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZGBGdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZGBGdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZGBGdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:33:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbZGBGdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:33:14 -0400
Date: Thu, 2 Jul 2009 08:33:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
	cfq_find_alloc_queue()
Message-ID: <20090702063316.GN23611@kernel.dk>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> <4A4B2C3D.7090800@cn.fujitsu.com> <20090701093235.GX23611@kernel.dk> <4A4C042F.7080403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C042F.7080403@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02 2009, Shan Wei wrote:
> Jens Axboe said:
> > On Wed, Jul 01 2009, Shan Wei wrote:
> >> Jens Axboe said:
> >>> Setup an emergency fallback cfqq that we allocate at IO scheduler init
> >>> time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> >>> punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> >>> never fails without having to ensure free memory.
> >>>
> >>> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >>> ---
> >>>  
> >>> @@ -1740,11 +1745,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
> >>>  		cfqq = *async_cfqq;
> >>>  	}
> >>>  
> >>> -	if (!cfqq) {
> >>> +	if (!cfqq)
> >>>  		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
> >>> -		if (!cfqq)
> >>> -			return NULL;
> >>> -	}
> >> I jsut reviewed the code and found that the check of cfqq is also redundant
> >> after doing cfq_get_queue() in cfq_set_request.
> >>
> >> The patch is based on Linus's main tree. 
> > 
> > It's not redundant in Linus' tree, cfq_get_queue() can return NULL for
> > != __GFP_WAIT.
> > 
> 
> Yes. So, the patch is only for "for-linus" branch of your tree, not for Linus's tree.
> 
> I noticed the patch is in your tree now, thanks.

Sorry I should have been more clear as well, I did merge it for
for-linus. It's just your original wording said if was against Linus'
main tree, where it didn't apply (the patch would apply, but it would be
wrong :-)

It's in upstream now.

-- 
Jens Axboe

