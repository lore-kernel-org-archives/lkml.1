Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZH0MCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZH0MCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZH0MCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:02:05 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:63310 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZH0MCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I4Cox382rNaSIKgvSpqzIqIy2RB1qhZOz/f/dg5HyMe85Sg4g4ONkTjBXPpgMC4TXk
         m9jwL/wepszkoCwNKf45mER58MdhQ6uRjInqhwoWMycscnbkv+dk8sBAjkEbfJhLXUme
         a6FryGSBaWZcxavsrRGfAi0W/Q+2NoPsgBANE=
MIME-Version: 1.0
In-Reply-To: <20090825105341.GB21335@csn.ul.ie>
References: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
	 <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
	 <202cde0e0908182248we01324em2d24b9e741727a7b@mail.gmail.com>
	 <20090819100553.GE24809@csn.ul.ie>
	 <202cde0e0908232314j4b90aa61pb4bcd0223ffbc087@mail.gmail.com>
	 <20090825105341.GB21335@csn.ul.ie>
Date: Fri, 28 Aug 2009 00:02:05 +1200
Message-ID: <202cde0e0908270502p3ea403ddr516945084372ffc4@mail.gmail.com>
Subject: Re: [PATCH 0/3]HTLB mapping for drivers (take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <linux-mm@mgebm.net>, Alexey Korolev <akorolev@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> If reservation only, then it is necessary to keep a gfp_mask for a
>> file somewhere. Would it be Ok to keep a gfp_mask for a file in
>> file->private_data?
>>
>
> I'm not seeing where this gfp mask is coming out of if you don't have zone
> limitations. GFP masks don't help you get contiguity beyond the hugepage
> boundary.
Contiguity is different. It is not related to GFP mask.
Requirement to have large contigous buffer is dictated by h/w. Since
this is very specific case it will need very specific solution. So if
providing this, affects on usability of kernel interfaces it's better
to left interfaces good.
But large DMA buffers with large amount of sg regions is more common.
DMA engine often requires 32 address space. Plus memory must be non
movable.
That raises another question: would it be correct assumiing that
setting sysctl hugepages_treat_as_movable won't make huge pages
movable?
>
> If you did need the GFP mask, you could store it in hugetlbfs_inode_info
> as you'd expect all users of that inode to have the same GFP
> requirements, right?
Correct. The same GFP per inode is quite enough.
So that way works. I made a bit raw implementation, more testing and
tuning and I'll send out another version.

Thanks,
Alexey
