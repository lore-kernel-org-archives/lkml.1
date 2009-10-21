Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZJUPgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZJUPgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZJUPgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZJUPgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:36:51 -0400
Date: Wed, 21 Oct 2009 17:36:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
Message-ID: <20091021153640.GS29477@redhat.com>
References: <20091021143042.14955.22470.stgit@dev.haskins.net>
 <20091021143453.14955.80578.stgit@dev.haskins.net>
 <20091021152621.GR29477@redhat.com>
 <4ADF2A1B.3010205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF2A1B.3010205@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:34:51AM -0400, Gregory Haskins wrote:
> Gleb Natapov wrote:
> > On Wed, Oct 21, 2009 at 10:34:53AM -0400, Gregory Haskins wrote:
> >> IRQFD currently uses a deferred workqueue item to execute the injection
> >> operation.  It was originally designed this way because kvm_set_irq()
> >> required the caller to hold the irq_lock mutex, and the eventfd callback
> >> is invoked from within a non-preemptible critical section.
> >>
> >> With the advent of lockless injection support in kvm_set_irq, the deferment
> >> mechanism is no longer technically needed. Since context switching to the
> >> workqueue is a source of interrupt latency, lets switch to a direct
> >> method.
> >>
> > kvm_set_irq is fully lockless only in MSI case. IOAPIC/PIC has mutexes.
> 
> Right, but irqfd by design only works with MSI (or MSI like edge
> triggers) anyway.  Legacy-type injections follow a different path.
> 
Ah, If this the case and it will stay that way then the change looks OK
to me.

> In any case, I didn't change the locking (you did ;).  You recently
> patched the irqfd code to remove the irq_lock, but we still had the
> deferment mechanism in place to avoid the mutex_lock from within the
> POLLIN callback.  Since the mutex_lock is now no longer acquired in this
> path, the deferment technique is not needed either.  Its only adding
> overhead for no purpose.  So I am simply cleaning that up to improve
> interrupt performance.
> 
> HTH,
> -Greg
> 
> 



--
			Gleb.
