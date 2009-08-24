Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbZHXGOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbZHXGOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZHXGO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:14:29 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:23714 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZHXGO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AZm6Nje7MqF97axari9uGTz1cV/C7enrglV/I7WiWIQpfX2A09iiacOgKmzhJ+SJWb
         kp2/GBZ1SWwdXCHv6RBe6zGgakT8WdanpK6f2zXiXb8IiJMrbQXcyCSIT8aQfuf99B8m
         HAFNcgc9Ig7JjXwaVftf2+aZv6NUtluAt9inQ=
MIME-Version: 1.0
In-Reply-To: <20090819100553.GE24809@csn.ul.ie>
References: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
	 <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
	 <202cde0e0908182248we01324em2d24b9e741727a7b@mail.gmail.com>
	 <20090819100553.GE24809@csn.ul.ie>
Date: Mon, 24 Aug 2009 18:14:30 +1200
Message-ID: <202cde0e0908232314j4b90aa61pb4bcd0223ffbc087@mail.gmail.com>
Subject: Re: [PATCH 0/3]HTLB mapping for drivers (take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <linux-mm@mgebm.net>, Alexey Korolev <akorolev@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

> How about;
>
>        o Extend Eric's helper slightly to take a GFP mask that is
>          associated with the inode and used for allocations from
>          outside the hugepage pool
>        o A helper that returns the page at a given offset within
>          a hugetlbfs file for population before the page has been
>          faulted.
>
> I know this is a bit hand-wavy, but it would allow significant sharing
> of the existing code and remove much of the hugetlbfs-awareness from
> your current driver.
>

I'm trying to write the solution you have described. The question I
have is about extension of hugetlb_file_setup function.
Is it supposed to allocate memory in hugetlb_file_setup function? Or
it is supposed to have reservation only.
If reservation only, then it is necessary to keep a gfp_mask for a
file somewhere. Would it be Ok to keep a gfp_mask for a file in
file->private_data?

Thanks,
Alexey
