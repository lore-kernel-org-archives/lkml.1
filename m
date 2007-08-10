Return-Path: <linux-kernel-owner+w=401wt.eu-S1765431AbXHJByQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431AbXHJByQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXHJByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:54:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:11403 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbXHJByC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uWRnNLobfIZ6bJc7h20j48KXFl8fpPIbVmpQY50RyhA+rpA20ozao3pIfz2pwEE3siA2y4+LfgfNhu/oGk5AveQWwyC41XyeVtAM3wdJmf8D7hiB31NPnS2t4Xha7jWFiYxyH3JdCGyzBHiYAfGLmqFwH17dVFSQjXBTvuI1GWU=
Message-ID: <4a5909270708091854n7c84ae9aj84170092a5eb61db@mail.gmail.com>
Date: Thu, 9 Aug 2007 21:54:01 -0400
From: "Daniel Phillips" <daniel.raymond.phillips@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
Cc: "Christoph Lameter" <clameter@sgi.com>, "Matt Mackall" <mpm@selenic.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "David Miller" <davem@davemloft.net>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20070808114636.7c6f26ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.603735000@chello.nl>
	 <Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
	 <20070808014435.GG30556@waste.org>
	 <Pine.LNX.4.64.0708081004290.12652@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0708081050590.12652@schroedinger.engr.sgi.com>
	 <20070808114636.7c6f26ab.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 8 Aug 2007 10:57:13 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
>
> > I think in general irq context reclaim is doable. Cannot see obvious
> > issues on a first superficial pass through rmap.c. The irq holdoff would
> > be pretty long though which may make it unacceptable.
>
> The IRQ holdoff could be tremendous.  But if it is sufficiently infrequent
> and if the worst effect is merely a network rx ring overflow then the tradeoff
> might be a good one.

Hi Andrew,

No matter how you look at this problem, you still need to have _some_
sort of reserve, and limit access to it.  We extend existing methods,
you are proposing to what seems like an entirely new reserve
management system.  Great idea, maybe, but it does not solve the
deadlocks.  You still need some organized way of being sure that your
reserve is as big as you need (hopefully not an awful lot bigger) and
you still have to make sure that nobody dips into that reserve further
than they are allowed to.

So translation: reclaim from "easily freeable" lists is an
optimization, maybe a great one.  Probably great.  Reclaim from atomic
context is also a great idea, probably. But you are talking about a
whole nuther patch set.  Neither of those are in themselves a fix for
these deadlocks.

Regards,

Daniel
