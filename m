Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYHVOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYHVOp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYHVOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:45:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYHVOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:45:20 -0400
Date: Fri, 22 Aug 2008 10:45:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080822144516.GA12479@infradead.org>
References: <20080815152938.4bc9d48c@infradead.org> <20080819210932.9bb348b9.akpm@linux-foundation.org> <20080822070054.5d466be9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822070054.5d466be9@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 07:00:54AM -0700, Arjan van de Ven wrote:
> On Tue, 19 Aug 2008 21:09:32 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > If we remove the first two checks then surely we can afford to add the
> > remaining check unconditionally and lose the new config option and its
> > ifdef.
> > 
> 
> Andi told me that this notifier is a hotpath for kprobes (systemtap)
> use models; at which point making this a config option makes sort of
> sense to get the last bit of performance out of that. Personally I would
> always want this option on for anything I run, and I suspect
> (enterprise) distros will just always turn it on as well since it's a
> good sanity check at low cost.
> 
> I'd be happy to lose the config (I think we have way too many unneeded
> ones of those already); I'll make a patch.

What about checking yourself? At least the braindead use of notiiers in
the pagefault path for kprobes (even unconditional on x86_64) is gone
now and replaced with proper kprobes hooks. The die notifier that's
also used by kprobes shouldn't be in a performance critical path.
