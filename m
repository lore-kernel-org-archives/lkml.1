Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZBKUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZBKUQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZBKUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:16:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZBKUQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:16:24 -0500
Date: Wed, 11 Feb 2009 18:14:44 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.28.4 freezing on a 32-bits x86 Thinkpad T43p
Message-ID: <20090211201444.GA14274@amt.cnet>
References: <20090204211106.GA30824@Krystal> <20090204211759.GK22608@elte.hu> <20090211193125.GA30975@Krystal> <20090211195038.GC25968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211195038.GC25968@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 08:50:38PM +0100, Ingo Molnar wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here is a new backtrace, taken with a huge amount of debugging active, which still 
> > points to an interrupt handler nested over kvm_mmu_pte_write as the culprit. It's 
> > weird that the kvm code gets called on my modest Pentium M laptop, which I think 
> > has no VT-x support at all. I am not running any KVM VMs on this machine. The 
> > problem still happens on 2.6.28.4, and Slub redzones did not identify any memory 
> > corruption. This could be due to kvm_mmu_pte_write which either should not be 
> > called at all, or due to improper interrupt disabling in this function.

This code is supposed to function on KVM guests only (kvm_mmu_pte_write
= paravirtual pte update).

There's some really screwed if its executing in a native machine.
