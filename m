Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXCUPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXCUPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXCUPrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:47:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:7235 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbXCUPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JqJoadJMXVEdEoSR/eEPmBpjAieSjStEnZAk38LNfekP0SrVV9EvR9pKye40/3m6Fg6YeVM3NdJiY9ndY1/Gv/Ed0GXcNpdQE1sGLa2MBkWf0u1Zuk1tzbwoWH5VH7iOMKr7vei+Tw2HOzNawzIKs882E0YbofG2mo+9CuO6a9M=
Message-ID: <84144f020703210847n53713bcj3a86d845cd3e56d6@mail.gmail.com>
Date: Wed, 21 Mar 2007 17:47:13 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Cc: "Christoph Lameter" <christoph@lameter.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070321163635.82697f08.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0703210737400.1573@graphe.net>
	 <20070321163635.82697f08.dada1@cosmosbay.com>
X-Google-Sender-Auth: 566e1efe112ab69d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Last time I checked 'struct page', they was no nodeid in it.

Hmm, page_to_nid() in include/linx/mm.h doesn't agree with you:

#ifdef NODE_NOT_IN_PAGE_FLAGS
extern int page_to_nid(struct page *page);
#else
static inline int page_to_nid(struct page *page)
{
        return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
}
#endif
