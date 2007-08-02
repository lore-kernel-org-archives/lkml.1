Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbXHBFDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbXHBFDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXHBFDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:03:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:52708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXHBFDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tylCpzwHqEtG+2WYZmzTmez3bqR9t9Rezk0qLy9RLpavZWA/5IyGa7R8AXkfawvFKslMM7PXUExbmgcDFCW3WPhqYet9eCkCmRzL9ZA81dA+LJsniCnKEia5tlBMRUvyw5qP/fZvHSkMtgth+Ycc37YQOWTbtEx1w+V6z06wPYg=
Message-ID: <46B1659D.30707@gmail.com>
Date: Thu, 02 Aug 2007 14:03:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 025 of 35] Treat rq->hard_nr_sectors as setting an overriding
 limit in the size of the request
References: <20070731112539.22428.patches@notabene>	<1070731021759.25484@suse.de>	<20070801174418.GI13674@htj.dyndns.org> <18097.20484.698570.267166@notabene.brown>
In-Reply-To: <18097.20484.698570.267166@notabene.brown>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Thursday August 2, htejun@gmail.com wrote:
>> This is pretty confusing.  In all other places, bi_size -> #sector
>> conversion is done by rounding down but only in blk_rq_bio_prep() it's
>> being rounded up.
>>
>> Is my following reasoning correct?
>>
>> It was okay till now because unaligned requests don't get merged and
>> also haven't done partial completions (end_that_request_first with
>> partial count)?  So till now, hard_nr_sectors and nr_sectors didn't
>> really matter for unaligned requests but now it matters because it's
>> considered while iterating over bvecs in rq.
> 
> Yes, that reasoning matches mine.
> 
>> If so, I think the correct thing to do would be changing bio_sectors()
>> to round up first or let block layer measure transfer in bytes not in
>> sectors.  I don't think everyone would agree with the latter tho.  I
>> (tentatively) think it would be better to represent length in bytes
>> tho.  A lot of requests which aren't aligned to 512 bytes pass through
>> the block layer and the mismatch can result in subtle bugs.
> 
> I suspect that having a byte count in 'struct request' would make
> sense too.  However I would rather avoid making that change myself - I
> think it would require reading and understanding a lot more code....
> 
> I cannot see anything that would go wrong with rounding up bio_sectors
> unconditionally, so I think I will take that approach for this patch
> series.

Yes, converting to nbytes will probably take a lot of work and probably
deserves a separate series if it's ever gonna be done.

Thanks.

-- 
tejun
