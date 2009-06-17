Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZFQQ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZFQQ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbZFQQZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:25:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbZFQQZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:25:56 -0400
Date: Wed, 17 Jun 2009 19:25:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090617162521.GE3089@redhat.com>
References: <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <20090616175300.GA24514@redhat.com> <4A37DFE2.2020506@novell.com> <20090617144540.GB3089@redhat.com> <4A39056E.1060409@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A39056E.1060409@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:02:06AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Tue, Jun 16, 2009 at 02:09:38PM -0400, Gregory Haskins wrote:
> >   
> >>> What do you mean by copy_to_user(other->mm) here?  If you are going to switch
> >>> to another mm, then I think current->mm must be valid (I think it's not enough
> >>> that you can sleep). So preemptible() might not be enough.
> >>>   
> >>>       
> >> I dont currently use switch_mm, if that is what you mean.  I save the
> >> task_struct into the appropriate context so current->mm doesn't matter
> >> to me.  I never use it.  All I need (afaik) is to acquire the proper
> >> mutex first.  I am not an MM expert, so perhaps I have this wrong but it
> >> does appear to work properly even from kthread context.
> >>
> >> -Greg
> >>
> >>
> >>     
> >
> > I think I saw get_user_pages + memcpy in your patch. Yes, that works
> > without switching contexts but it's slower than copy to user if you are
> > in the right context, and AFAIK it's slower than get_user_pages_fast.
> >
> >   
> Yeah, understood.  It will definitely be interesting to try that
> optimization with switch_mm that you suggested.

BTW, I'm kind of confused - in your patch you do get_task_struct: does this
guarantee that mm is not going aways?

> On that front, would "if (p == current)" still work even if we don't
> have the "signal_task()" hint?
> 

Donnu.

-- 
MST
