Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZKBHHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZKBHHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZKBHHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:07:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbZKBHHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:07:19 -0500
Date: Mon, 2 Nov 2009 09:07:20 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] Add shared memory hypercall to PV Linux guest.
Message-ID: <20091102070720.GF29477@redhat.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
 <1257076590-29559-2-git-send-email-gleb@redhat.com>
 <4AEE5FA3.1020104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEE5FA3.1020104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 11:27:15PM -0500, Rik van Riel wrote:
> On 11/01/2009 06:56 AM, Gleb Natapov wrote:
> >Add hypercall that allows guest and host to setup per cpu shared
> >memory.
> 
> While it is pretty obvious that we should implement
> the asynchronous pagefaults for KVM, so a swap-in
> of a page the host swapped out does not stall the
> entire virtual CPU, I believe that adding extra
> data accesses at context switch time may not be
> the best tradeoff.
> 
> It may be better to simply tell the guest what
> address is faulting (or give the guest some other
> random unique number as a token).  Then, once the
> host brings that page into memory, we can send a
> signal to the guest with that same token.
> 
> The problem of finding the task(s) associated with
> that token can be left to the guest.  A little more
> complexity on the guest side, but probably worth it
> if we can avoid adding cost to the context switch
> path.
> 
This is precisely what this series implements. The function below
is leftover from previous implementation, not used by the rest of the
patch and removed by a later patch. Just a left over from rebase. Sorry
about that. Will be fixed for future submissions.

> >+static void kvm_end_context_switch(struct task_struct *next)
> >+{
> >+	struct kvm_vcpu_pv_shm *pv_shm =
> >+		per_cpu(kvm_vcpu_pv_shm, smp_processor_id());
> >+
> >+	if (!pv_shm)
> >+		return;
> >+
> >+	pv_shm->current_task = (u64)next;
> >+}
> >+
> 
> 
> 
> -- 
> All rights reversed.

--
			Gleb.
