Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZECU7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZECU7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZECU66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:58:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZECU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:58:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ON8o5HMTBFfv5zHhBYUmV83kp6YnwBEcO1doAP5Ht1fHwzx17PdborzbtJTrVaGT6
	FRlYsVlqCJQ6A0zabjfwQ==
Date: Sun, 3 May 2009 13:58:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
In-Reply-To: <20090503204542.GJ4615@lenovo>
Message-ID: <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
References: <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com> <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com> <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop>
 <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Cyrill Gorcunov wrote:

> @@ -1685,7 +1687,9 @@ nopage:
>  		dump_stack();
>  		show_mem();
>  	}
> -	return page;
> +	if (unlikely(gfp_mask & __GFP_PANIC))
> +		panic("Out of memory: panic due to __GFP_PANIC\n");
> +	return NULL;
>  got_pg:
>  	if (kmemcheck_enabled)
>  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> 

If we really want a __GFP_PANIC flag for this purpose, I'd recommend also 
emitting the order and gfpmask in the panic() message since it may not be 
immediately obvious from the caller.
