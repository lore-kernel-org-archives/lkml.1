Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZEDK42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZEDK42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZEDK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:56:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZEDK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:56:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BVao//Dd3gtpkoci2wFf5S7/5dLqDZYiBI985u76q25f/QXbqnP3I8JBUe+lmMQis
	1wEit6xmaY4mvuyr+RlPQ==
Date: Mon, 4 May 2009 03:56:10 -0700 (PDT)
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
In-Reply-To: <20090504101121.GE4173@lenovo>
Message-ID: <alpine.DEB.2.00.0905040353290.24987@chino.kir.corp.google.com>
References: <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
 <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop> <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop> <20090504100106.GD4173@lenovo> <20090504101121.GE4173@lenovo>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Cyrill Gorcunov wrote:

> @@ -1685,7 +1687,12 @@ nopage:
>  		dump_stack();
>  		show_mem();
>  	}
> -	return page;
> +	if (unlikely((gfp_mask & __GFP_PANIC))) {

Too many parentheses and this doesn't need the unnecessary braces.

> +		panic("Out of memory: panic due to __GFP_PANIC.\n"
> +			"%s order:%d, mode:0x%x\n", p->comm,
> +			order, gfp_mask);

The extra newline in this statement doesn't seem necessary, it's just one 
less line that will be visible on the frozen screen.  I also think calling 
this 'gfp_mask' instead of 'mode' is more appropriate just like the oom 
killer does.

> +	}
> +	return NULL;
>  got_pg:
>  	if (kmemcheck_enabled)
>  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> 
