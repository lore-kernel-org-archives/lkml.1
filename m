Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXCUM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXCUM1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXCUM1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:27:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:48361 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXCUM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XCwjaLL35IBUfLFT84azulLh1/vXGTrsVk5QZfN3k/soNgU70sDiwN6AcX67e8InyVRjDhQUnCYqq6cb13BWyMfn3BlGLAG6HNavB9ZfdThTYVLW/BXb+nk858ICQCLjkzzizwtgghDQcfK5STeHyGqc4fbgE8OY+s/+GPFoNDU=
Message-ID: <84144f020703210527x591d58c6i9ae7919d2dde8256@mail.gmail.com>
Date: Wed, 21 Mar 2007 14:27:31 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070321102231.7288f231.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321102231.7288f231.dada1@cosmosbay.com>
X-Google-Sender-Auth: 0808acfe70c1a20e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> +#ifdef KEEP_NODEID_IN_PAGE
> +       /* kmem_cache addresses must be multiple of 64 */
> +       cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
> +                                       max(64, cache_line_size()));
> +#else
>         cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
>                                         cache_line_size());
> +#endif

Please introduce cache_cache_align() to hide the #ifdeffing.
