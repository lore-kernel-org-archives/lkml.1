Return-Path: <linux-kernel-owner+w=401wt.eu-S936127AbZDISgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936127AbZDISgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935905AbZDISgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:36:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935895AbZDISgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:36:22 -0400
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <49DE354E.9000607@goop.org>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	 <1239292496.7647.607.camel@twins>
	 <20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
	 <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
	 <1239296031.21985.28.camel@twins> <1239298734.21985.113.camel@twins>
	 <49DE354E.9000607@goop.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 20:34:35 +0200
Message-Id: <1239302075.4557.4225.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 10:50 -0700, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > On Thu, 2009-04-09 at 18:53 +0200, Peter Zijlstra wrote:
> >
> >   
> >> I was looking at how an monitor-wait could be used here, but that
> >> appears non-trivial, there's two variables we're watching, lock->owner
> >> and rq->curr, either could change.
> >>
> >> Reducing that to 1 seems an interesting problem :-)
> >>     
> >
> > How about something like this?
> >
> > Does it make sense to implement an monitor-wait spinlock for the virt
> > case as well? Avi, Jeremy?
> >   
> 
> Last time I tried to put mwait in a spinlock, Arjan (or HPA?) said that 
> mwait takes approx a week and a half to wake up, and that it was really 
> only useful for idle power savings.

Yeah, sad that.

> Has that changed?

Nothing much, I was thinking perhaps it would make sense for the virt
case, but if its not properly virtualized then its pretty useless
indeed.

monitor-wait is basically a hardware/hv futex like thing, so I thought
it might help -- spinning in a guest is pretty painful.

