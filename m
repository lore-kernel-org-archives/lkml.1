Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbZDGB3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbZDGB3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZDGB30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:29:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZDGB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:29:26 -0400
Date: Mon, 6 Apr 2009 21:29:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
In-Reply-To: <1239067146.22733.260.camel@macbook.infradead.org>
Message-ID: <alpine.DEB.2.00.0904062127420.24008@gandalf.stny.rr.com>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>  <20090406175918.c38654b2.akpm@linux-foundation.org>  <1239066583.22733.258.camel@macbook.infradead.org> <1239067146.22733.260.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, David Woodhouse wrote:

> On Mon, 2009-04-06 at 18:09 -0700, David Woodhouse wrote:
> > 
> > I'm unconvinced by the fix -- can we find a way to fix the if() macro so
> > that normal (if fugly) C code like this doesn't doesn't need this kind
> > of workaround?
> 
> Something like this perhaps? I'd reformat it but dinner calls...

Use emacs Ctrl-c / ;-)

> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 6faa7e5..1da2e72 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -114,7 +114,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>   * "Define 'is'", Bill Clinton
>   * "Define 'if'", Steven Rostedt
>   */
> -#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
> +#define if(cond, ...) if (__builtin_constant_p((cond, ## __VA_ARGS__)) ? !!(cond, ## __VA_ARGS__) : \
>  	({								\
>  		int ______r;						\
>  		static struct ftrace_branch_data			\
> @@ -125,7 +125,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  				.file = __FILE__,			\
>  				.line = __LINE__,			\
>  			};						\
> -		______r = !!(cond);					\
> +		______r = !!(cond, ## __VA_ARGS__);					\
>  		______f.miss_hit[______r]++;					\
>  		______r;						\
>  	}))
> 

If this works then (after reformating)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

