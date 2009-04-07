Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbZDGWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbZDGWm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbZDGWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:42:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:3670 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbZDGWmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:42:18 -0400
MIME-Version: 1.0
In-Reply-To: <f73f7ab80904071540w3d298c3bh386b46d5685f746e@mail.gmail.com>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407055245.GA10406@elte.hu>
	 <1239084280.22733.404.camel@macbook.infradead.org>
	 <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>
	 <20090407090229.GA2467@elte.hu>
	 <1239104035.22733.443.camel@macbook.infradead.org>
	 <alpine.LFD.2.00.0904070751510.4010@localhost.localdomain>
	 <alpine.LFD.2.00.0904070759050.4010@localhost.localdomain>
	 <f73f7ab80904071540w3d298c3bh386b46d5685f746e@mail.gmail.com>
Date: Tue, 7 Apr 2009 18:42:17 -0400
Message-ID: <f73f7ab80904071542r1d3e5e1au21c8c4ded9d36f7d@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
From: Kyle Moffett <kyle@moffetthome.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, resent the original HTML email as plain text, sorry...

On Tue, Apr 7, 2009 at 10:59 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 7 Apr 2009, Linus Torvalds wrote:
> >
> > Can we please do it something like the following instead:
> >
> >       #define if(a, ...) \
> >               __trace_if( (a, ## __VA_ARGS__) )
> >
> > so that you don't need to do that ", ## __VA_ARGS__" thing three times?
>
> IOW, does this (TOTALLY UNTESTED) patch work?
>
>                Linus
>
> -#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :         \
> +#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
> +#define __trace_if(cond) \
> +       if (__builtin_constant_p((cond)) ? !!(cond) :                   \

Umm, why not just use the much nicer pre-C99 GCC syntax?  It
automatically makes "cond" expand into the full comma-separated
argument list.  No other changes should be necessary.  IOW, something
like this:

-#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :         \
+#define if(cond...) if (__builtin_constant_p((cond)) ? !!(cond) :         \

Cheers,
Kyle Moffett
