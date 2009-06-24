Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbZFXS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbZFXS6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbZFXS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:58:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZFXS6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:58:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
In-Reply-To: Oleg Nesterov's message of  Wednesday, 24 June 2009 17:21:43 +0200 <20090624152143.GB23848@redhat.com>
References: <20090622170437.GA4906@redhat.com>
	<20090624091316.73D0F4059B@magilla.sf.frob.com>
	<20090624152143.GB23848@redhat.com>
X-Zippy-Says: Well, I'm a classic ANAL RETENTIVE!!  And I'm looking for a way to
    VICARIOUSLY experience some reason to LIVE!!
Message-Id: <20090624185701.AA74C4059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 11:57:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the check below is orthogonal to eligible_child(). 

Yes.

> Not sure
> eligible_child() can really help, but otoh it is cheap and doesn't hurt.
> But perhaps we can kill it later.

No, it's a very good check to have.  It is ideal for waitpid(ONE_PID,...)
uses, which are also probably quite common.

> > (and ->parent is perhaps
> > not right in all cases there).
> 
> I think this is right... Except I'd like to avoid using ->parent.

Agreed.  The not-right case I had in mind was do_notify_parent_cldstop
where maybe it could be ->real_parent of the untraced group_leader.

> > Your two patches as they are look safe and useful to me and I hope they can
> > go in soon.
> 
> Thanks.
> 
> Yes I think these 2 patches should be applied first, even if eligible_child()
> itself doesn't buy much. It will be cleaner if we add "real" checks on top.

Agreed.


Thanks,
Roland
