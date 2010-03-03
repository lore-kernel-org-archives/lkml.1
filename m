Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0CCMVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:21:51 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39358 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0CCMVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:21:49 -0500
Date: Wed, 3 Mar 2010 13:21:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Message-ID: <20100303122148.GS5768@kernel.dk>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org> <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org> <20100303073014.GE5768@kernel.dk> <87zl2per3d.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zl2per3d.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, Dmitry Monakhov wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Wed, Mar 03 2010, Dmitry Monakhov wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >> 
> >> > On Sat, Feb 27 2010, Dmitry Monakhov wrote:
> >> >> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
> >> >> against this value. But in case of fs_optimization merge we compare
> >> >> with wrong value. This patch must be included in
> >> >>  b428cd6da7e6559aca69aa2e3a526037d3f20403
> >> >> But accidentally i've forgot to add this in the initial patch.
> >> >> To make things straight let's replace all such checks.
> >> >> In fact this makes code easy to understand.
> >> >
> >> > Agree, applied.
> >> Ohh.. as you already know this patch break dm-layer. Sorry.
> >> This is because dm->merge may return more than requested. So correct
> >> check must test against less what requested. Correct patch attached.
> >
> > Have you tested this with dm and md (ie actual users of the merge_bvec
> > functionality) this time?
> Yes. This time both md and dm are ok.

Good, I'll queue it up for testing.

-- 
Jens Axboe

