Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZKZKrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZKZKrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZKZKrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:47:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZKZKrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:47:36 -0500
Date: Thu, 26 Nov 2009 05:47:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091126104722.GA8316@infradead.org>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org> <20091126091052.GF1389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126091052.GF1389@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 10:10:52AM +0100, Ingo Molnar wrote:
> > [...]  Given that's it's pretty much too later for the 2.6.33 cycle 
> > anyway I'd suggest you make sure the remaining two major architectures 
> > (arm and mips) get converted, and if the remaining minor architectures 
> > don't manage to get their homework done they're left without ptrace.
> 
> I suspect the opinion of the ptrace maintainers matters heavily whether 
> it's appropriate for v2.6.33. You are not going to maintain this, they 
> are.

I am whoever like many others going to use it.  And throwing in new code
a few days before the merge window closes and thus not getting any of
the broad -next test coverage is a pretty bad idea.  In the end
it will be the maintainers ruling but that doesn't make it a good idea
from the engineering point of view.

> Regarding porting it to even more architectures - that's pretty much the 
> worst idea possible. It increases maintenance and testing overhead by 
> exploding the test matrix, while giving little to end result. Plus the 
> worst effect of it is that it becomes even more intrusive and even 
> harder (and riskier) to merge.

But it doesn't.  Take a look at what these patches actually do, they
basically introduce a new utrace layer, and (conditionally) rewrite
ptrace to use it.  The arch support isn't actually part of these patches
directly but rather the cleanup of the underlying arch ptrace code to
use regsets, tracehooks and co so that the new ptrace code can use.

What the patches in the current form do is to introduce two different
ptrace implementations, with one used on the architectures getting most
testing and another secondary one for left over embedded or dead
architectures with horrible results.  So removing the old one is much
better.  The arm ptrace rewrite has already been posted by Roland, btw
including some feedback from Russell, but nothing really happened to it.

