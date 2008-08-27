Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbYH0QZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbYH0QZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYH0QYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:24:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:31851 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbYH0QYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h+UlKUGvli7qpy8r2f7k6lgA597PdCMhku2ZDGF+FWc2NjLg/I6E6koiLAc3qc8F5L
         /57iCbNmKQIeQWI0m0WAmjCpdsGNeIJjerloLdZEBExHltpxx1AqXTDyUXhCawPdOJwC
         53MJ80RNWufDtFrDr/NNbdo4C2GBXyU81/h2c=
Message-ID: <f7848160808270924v7ba4882bh45fc4cace51a2d77@mail.gmail.com>
Date: Wed, 27 Aug 2008 12:24:08 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <20080827142142.303cdba8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <20080826232411.GC11734@cs181140183.pp.htv.fi>
	 <20080827092528.780916bd@lxorguk.ukuu.org.uk>
	 <f7848160808270552u2ee66167x912a68e0bf8b25bf@mail.gmail.com>
	 <20080827142142.303cdba8@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 9:21 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> By your logic though, XFS on x86 should work fine with 4K stacks -
>> many will attest that it does not and blows up due to stack issues.
>>
>> I have first hand experiences of things blowing up with deep call
>> chains when using 4K stacks where 8K worked just fine on same
>> workload.
>>
>> So there is definitely some other problem with 4K stacks.
>
> Nothing of the sort. If it blows up with a 4K stack it will almost
> certainly blow up with an 8K stack *eventually* - when a heavy stack usage
> coincides with a heavy stack using IRQ handler.
>
> You won't catch it in simple testing, you won't catch it in trivial
> simulation and it'll be incredibly hard to reproduce. Not the kind of bug
> you want in a production system really. IRQ stacks make things much more
> predictable.


I see - so if I end up having a workload on 8k where heavy stack using
IRQs and deep kernel call chains come at the same time - even 8K will
blow up.
So 4K will blow too except that it doesn't require IRQs also to use
heavy stack, just XFS is good enough :)

It then seems like the IRQs using lot of stack is not so much of a
problem in the current kernel as much as deeper call chains and stack
usage of normal non-irq path code is.
So 8k makes it possible for the deeper call chains of non-irq path to
survive since they get better part of the 8K to themselves and IRQs
can do with less almost always.

At least that's what I can derive from the fact that we do not have
lots of reports of 8K stack blowing up.

Thanks

Parag
