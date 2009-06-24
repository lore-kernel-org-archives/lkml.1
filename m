Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZFXShI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZFXShI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXSg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:36:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZFXSg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:36:57 -0400
Date: Wed, 24 Jun 2009 17:21:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
Message-ID: <20090624152143.GB23848@redhat.com>
References: <20090622170437.GA4906@redhat.com> <20090624091316.73D0F4059B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624091316.73D0F4059B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Roland McGrath wrote:
>
> Looks good, I'm glad to see this revived.
>
> I note that even simpler than eligible_child() is just:

I think the check below is orthogonal to eligible_child(). Not sure
eligible_child() can really help, but otoh it is cheap and doesn't hurt.
But perhaps we can kill it later.


> 	if ((wo->wo_flags & __WNOTHREAD) && wo->child_wait.private != p->parent)
> 		return 0;
>
> IIRC that is the test that Ratan's original patch used to address the
> particular application usage that first troubled him.

Aha, now I see what was the problem with Ratan's workload.

> But probably this
> is already what you meant by "more clever later"

I didn't mean this particular optimization, but it looks good to me.

> (and ->parent is perhaps
> not right in all cases there).

I think this is right... Except I'd like to avoid using ->parent.

> Your two patches as they are look safe and useful to me and I hope they can
> go in soon.

Thanks.

Yes I think these 2 patches should be applied first, even if eligible_child()
itself doesn't buy much. It will be cleaner if we add "real" checks on top.

Oleg.

