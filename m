Return-Path: <linux-kernel-owner+w=401wt.eu-S969167AbXEIFZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969167AbXEIFZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966260AbXEIFZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:25:25 -0400
Received: from mx10.go2.pl ([193.17.41.74]:43338 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966105AbXEIFZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:25:24 -0400
Date: Wed, 9 May 2007 07:31:44 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070509053144.GA995@ff.dom.local>
References: <20070508103348.GC1772@ff.dom.local> <20070508163358.9cc482a8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508163358.9cc482a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:33:58PM -0700, Andrew Morton wrote:
> On Tue, 8 May 2007 12:33:48 +0200
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > 
> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> > 
> > ---
> > 
> > diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
> > --- 2.6.21-mm1-/kernel/timer.c	2007-05-08 11:54:48.000000000 +0200
> > +++ 2.6.21-mm1/kernel/timer.c	2007-05-08 12:05:11.000000000 +0200
> > @@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
> >  /* Functions below help us manage 'deferrable' flag */
> >  static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
> >  {
> > -	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
> > +	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
> >  }
...
> The change makes sense, but does it actually "fix" anything?
> 

Yes - this first place fixes logical error, so it's a sin
- even if not punishable in practice. (It's also unnecessary
test for long to int conversion.)

Other changes are only BTW.

Regards,
Jarek P.
