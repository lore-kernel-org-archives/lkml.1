Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZEDJ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZEDJ5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZEDJ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:57:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39549 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZEDJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:57:12 -0400
Subject: Re: introducing __GFP_PANIC
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090504090825.GC4173@lenovo>
References: <20090503121228.GC4615@lenovo>
	 <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo>
	 <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com>
	 <20090503172338.GG4615@lenovo>
	 <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
	 <20090503204542.GJ4615@lenovo>
	 <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
	 <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop>
	 <20090504090825.GC4173@lenovo>
Date: Mon, 04 May 2009 12:57:11 +0300
Message-Id: <1241431031.21088.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 13:08 +0400, Cyrill Gorcunov wrote:
> Index: linux-2.6.git/mm/oom_kill.c
> =====================================================================
> --- linux-2.6.git.orig/mm/oom_kill.c
> +++ linux-2.6.git/mm/oom_kill.c
> @@ -422,6 +422,16 @@ static int oom_kill_process(struct task_
>  	return oom_kill_task(p);
>  }
>  
> +void oom_panic(gfp_t gfp_mask, unsigned int order)
> +{
> +	if (likely(!(gfp_mask & __GFP_PANIC)))
> +		return;
> +
> +	panic("Out of memory: panic due to __GFP_PANIC.\n"
> +		"%s order:%d, mode:0x%x\n", current->comm,
> +		order, gfp_mask);
> +}

I think this just makes things harder to follow. It has one call-site so
why not inline this there?

