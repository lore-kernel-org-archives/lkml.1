Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYCYV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYCYV1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYCYV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:27:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbYCYV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c36S3nev+1b39uInocy7ClecfTj/+KfbUgpHUjAGrk9CT6QQIavsZnBXoUBonU/fe1zQdpDFC7Bd9lrDQ2+xC4DkQ45bGLi9Fcd15LZ3IG1qrW4gVu34YFRr2N/TZsEHzMKPgFfmKpsXBvW5c/0oeRWrg/7inD2Ut9lOTQyeS+c=
Message-ID: <6101e8c40803251427t777b0afdlf9e49e36b193c729@mail.gmail.com>
Date: Tue, 25 Mar 2008 22:27:25 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] list_add corruption in slab.c
Cc: "Daniel Yeisley" <dan.yeisley@unisys.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, "Christoph Lameter" <clameter@sgi.com>, mel@csn.ul.ie
In-Reply-To: <47E96B0A.2010906@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1206464258.13473.11.camel@localhost.localdomain>
	 <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
	 <1206477858.8810.3.camel@localhost.localdomain>
	 <47E96B0A.2010906@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m2PLT4nq017114

Hi Pekka
this patch for 2.6.22?(http://repo.or.cz/w/linux-2.6.22.y-op.git)
--8<--        /* 1) create the cache_cache */        INIT_LIST_HEAD(&cache_chain);        list_add(&cache_cache.next, &cache_chain);        cache_cache.colour_off = cache_line_size();        cache_cache.array[smp_processor_id()] = &initarray_cache.cache;        cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];-->8--from 2.6.22's slab.c
On 3/25/08, Pekka Enberg <penberg@cs.helsinki.fi> wrote:> Hi Daniel,>> Daniel Yeisley wrote:> > I actually saw that initkmem_list reference, but didn't change it since> > my original patch fixed my list corruption.  Anyway, I made the changed> > and tested it.  The system booted fine.>> Yeah, but the second change is needed; otherwise we forget to fix up> some of the bootstrap caches.>>  > ï»¿Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>>> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>>> Mel, as this change is related to the memoryless node fix that went in> 2.6.24, any chance you'd give this patch a spin on your machines so we> can get the fix in 2.6.25 and 2.6.24-stable?>> 			Pekka> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>

-- Thanks,Oliverÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
