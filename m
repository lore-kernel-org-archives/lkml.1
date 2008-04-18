Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbYDRETc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbYDRETc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYDRETW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:19:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbYDRETV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:19:21 -0400
Date: Thu, 17 Apr 2008 21:19:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-Id: <20080417211905.8ff769fa.akpm@linux-foundation.org>
In-Reply-To: <1208491086.6958.381.camel@pasglop>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	<20080413171953.bde5e9ac.akpm@linux-foundation.org>
	<1208133506.6958.82.camel@pasglop>
	<20080413191338.9776ebd0.akpm@linux-foundation.org>
	<1208491086.6958.381.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 13:58:06 +1000 Benjamin Herrenschmidt <benh@ozlabs.org> wrote:

> 
> > > > otoh, if only one .c file will ever call this function then I think that
> > > > all problems are solved by
> > > > 
> > > > a) moving the above ifdeffery into the .c file
> > > > b) adding a comment explaining which arch file must provide the override
> > > > c) directly including that file from within the .c file.
> > > 
> > > I can definitely do that. I have no problem either way. I can add to all
> > > archs too, it's just that whatever way I choose, some people won't be
> > > happy with it :-)
> > > 
> > > Anyway, I'll move the ifdeferry to init/main.c then.
> > 
> > Thanks ;)
> > 
> > I'm still wounded by my recent encounter with set_softirq_pending()
> > and or_softirq_pending().
> 
> Well, looking there, I saw we already used weak symbols for that

Yes, `weak' is a nice solution.  It does add a few bytes of text which we
could avoid with compile-time trickery, but only a very few.

Plus this is __init anyway, although I don't know how well the combination
of `weak' and __init works.


> so what
> about the patch below ?

I like it, but the compiler won't ;)

> If you're ok, I'll re-send with appropriate sob
> & adapted powerpc part.

Sure.

> +void __init __attribute__((weak) thread_info_cache_init(void)

s/weak)/weak))/
