Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXHBDbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXHBDbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXHBDbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:31:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:49461 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXHBDbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:31:32 -0400
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <htejun@gmail.com>
Date: Thu, 2 Aug 2007 13:31:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18097.20484.698570.267166@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 025 of 35] Treat rq->hard_nr_sectors as setting an overriding limit in the size of the request
In-Reply-To: message from Tejun Heo on Thursday August 2
References: <20070731112539.22428.patches@notabene>
	<1070731021759.25484@suse.de>
	<20070801174418.GI13674@htj.dyndns.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 2, htejun@gmail.com wrote:
> 
> This is pretty confusing.  In all other places, bi_size -> #sector
> conversion is done by rounding down but only in blk_rq_bio_prep() it's
> being rounded up.
> 
> Is my following reasoning correct?
> 
> It was okay till now because unaligned requests don't get merged and
> also haven't done partial completions (end_that_request_first with
> partial count)?  So till now, hard_nr_sectors and nr_sectors didn't
> really matter for unaligned requests but now it matters because it's
> considered while iterating over bvecs in rq.

Yes, that reasoning matches mine.

> 
> If so, I think the correct thing to do would be changing bio_sectors()
> to round up first or let block layer measure transfer in bytes not in
> sectors.  I don't think everyone would agree with the latter tho.  I
> (tentatively) think it would be better to represent length in bytes
> tho.  A lot of requests which aren't aligned to 512 bytes pass through
> the block layer and the mismatch can result in subtle bugs.

I suspect that having a byte count in 'struct request' would make
sense too.  However I would rather avoid making that change myself - I
think it would require reading and understanding a lot more code....

I cannot see anything that would go wrong with rounding up bio_sectors
unconditionally, so I think I will take that approach for this patch
series.

Thanks.

NeilBrown
