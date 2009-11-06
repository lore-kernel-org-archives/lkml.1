Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbZKFRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbZKFRFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZKFRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:05:35 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:54245 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759448AbZKFRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:05:34 -0500
Date: Fri, 6 Nov 2009 12:03:55 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
In-Reply-To: <4AF45109.7070503@kernel.org>
Message-ID: <alpine.DEB.1.10.0911061159450.5187@V090114053VZO-1>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org>
 <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu> <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu> <4AF3E3D1.7010101@kernel.org> <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>
 <4AF45109.7070503@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, Tejun Heo wrote:

> vmalloc/vfree is an allocator in the kernel and can't be called from
> irq context and doesn't take gfp flags.  percpu allocator being
> dependent on vmalloc area, it's gonna be a bit tricky.  It's
> definitely doable but I'm still not quite sure whether the benfit
> would worth the added complexity.  The only known use case is for lazy
> allocation from memory allocator, right?  How much does it hurt not to
> have that lazy allocation?

Nick did some work recently on the vmalloc subsystem and one of the
intents was (well I think so at least) to make it usable for fsblock which
requires virtual mappings. Maybe even from an atomic context.

Potential use cases for atomic percpu allocs exist all over the kernel. If
you need to allocate a structure in an atomic context then attaching per
cpu information to that structure will require also per cpu allocation in
an atomic context.

We discourage atomic allocations and they are rare. Atomic allocs are
allowed to fail. But they are occasionally necessary.


