Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXEEPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXEEPnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423229AbXEEPne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:43:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423215AbXEEPnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:43:06 -0400
Message-ID: <84144f020705050314s36510c98j70d1ca8e3770f00e@mail.gmail.com>
Date: Sat, 5 May 2007 13:14:07 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [RFC 1/3] SLUB: slab_ops instead of constructors / destructors
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <20070504221708.363027097@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504221555.642061626@sgi.com>
	 <20070504221708.363027097@sgi.com>
X-Google-Sender-Auth: cde46eead1656136
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, clameter@sgi.com <clameter@sgi.com> wrote:
> This patch gets rid constructors and destructors and replaces them
> with a slab operations structure that is passed into SLUB.

Looks good to me.

On 5/5/07, clameter@sgi.com <clameter@sgi.com> wrote:
> +struct slab_ops {
> +       /* FIXME: ctor should only take the object as an argument. */
> +       void (*ctor)(void *, struct kmem_cache *, unsigned long);
> +       /* FIXME: Remove all destructors ? */
> +       void (*dtor)(void *, struct kmem_cache *, unsigned long);
> +};

For consistency with other operations structures, can we make this
struct kmem_cache_operations or kmem_cache_ops, please?
