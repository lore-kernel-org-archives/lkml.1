Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYD0KXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYD0KXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYD0KXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:23:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29243 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYD0KXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:23:41 -0400
Date: Sun, 27 Apr 2008 12:23:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function  calls
Message-ID: <20080427102335.GS12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <4812CF5B.4080902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4812CF5B.4080902@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >--- a/arch/x86/kernel/smp.c
> >+++ b/arch/x86/kernel/smp.c
> >  
> [...]
> >+void arch_send_call_function_single_ipi(int cpu)
> > {
> >  
> [...]
> >+void arch_send_call_function_ipi(cpumask_t mask)
> > {
> >  
> [...]
> >--- a/arch/x86/xen/smp.c
> >+++ b/arch/x86/xen/smp.c
> >+void arch_send_call_function_ipi(cpumask_t mask)
> >+{
> >  
> [...]
> >+void arch_send_call_function_single_ipi(int cpu)
> >+{
> >+	xen_send_IPI_mask(cpumask_of_cpu(cpu), 
> >XEN_CALL_FUNCTION_SINGLE_VECTOR);
> > 
> 
> Xen vs native is a runtime choice, so you can't just statically define 
> arch_send_call_function(_single)_ipi for each.  You need to define the 
> arch_* functions once, make them call via smp_ops, and call into the 
> respective native and Xen versions of the ipi functions.

Noted, I'll add it to smp_ops (like smp_call_function_mask() was
before).

> Aside from that it looks good, with a very appealing code size reduction.

Thanks!

-- 
Jens Axboe

