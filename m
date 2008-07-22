Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYGVVJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYGVVJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYGVVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:09:33 -0400
Received: from ag-out-0708.google.com ([72.14.246.247]:28798 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbYGVVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=b65HtWpU/IvJ17rk5bzILpjYd6zpNfM/rxj14yWGg5VEcCQ79aKOSbj2eQP3emN1Xu
         h3vqJiOpSsA7Ie1nhYBaoA39RptLudrxCPQkQcOON8WIrBF3pK6fuxFr0Wk8WNY4wQIV
         NdD1fkxzaw2gjA2iPebMjmELq3WKqlqEtz9Zc=
Date: Wed, 23 Jul 2008 00:07:52 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Matt Mackall <mpm@selenic.com>
Cc: penberg@cs.helsinki.fi, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [RFC PATCH 4/4] kmemtrace: SLOB hooks.
Message-ID: <20080722210751.GA14810@localhost>
References: <1216751808-14428-1-git-send-email-eduard.munteanu@linux360.ro> <1216751808-14428-2-git-send-email-eduard.munteanu@linux360.ro> <1216751808-14428-3-git-send-email-eduard.munteanu@linux360.ro> <1216751808-14428-4-git-send-email-eduard.munteanu@linux360.ro> <1216751808-14428-5-git-send-email-eduard.munteanu@linux360.ro> <1216760035.15519.113.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216760035.15519.113.camel@calx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 03:53:55PM -0500, Matt Mackall wrote:
> 
> On Tue, 2008-07-22 at 21:36 +0300, Eduard - Gabriel Munteanu wrote:
> > -static inline void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
> > +static __always_inline void *kmem_cache_alloc(struct kmem_cache *cachep,
> > +					      gfp_t flags)
> >  {
> >  	return kmem_cache_alloc_node(cachep, flags, -1);
> >  }
> 
> Why is this needed? builtin_return?

If we don't use __always_inline, we can't be sure whether it's inlined
or not. And we don't know if we need _THIS_IP_ or _RET_IP_ (equivalent
to __builtin_return_address(0)). Simple, plain 'inline' does not
guarantee GCC will inline that function, nor does it warn us if it is
not inlined.

