Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZKFQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZKFQj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbZKFQj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:39:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:50877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443AbZKFQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:39:57 -0500
Message-ID: <4AF45109.7070503@kernel.org>
Date: Sat, 07 Nov 2009 01:38:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu> <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu> <4AF3E3D1.7010101@kernel.org> <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 6 Nov 2009, Tejun Heo wrote:
> 
>> Ingo Molnar wrote:
>>> My question is, why do we do flags save/restore in pcpu-alloc?
>> That's strictly for calls from sched_init().
> 
> Right its a hack for 2.6.32. Fix it the right way by making the per cpu
> allocator take gfp flags like any other allocator in the kernel.

vmalloc/vfree is an allocator in the kernel and can't be called from
irq context and doesn't take gfp flags.  percpu allocator being
dependent on vmalloc area, it's gonna be a bit tricky.  It's
definitely doable but I'm still not quite sure whether the benfit
would worth the added complexity.  The only known use case is for lazy
allocation from memory allocator, right?  How much does it hurt not to
have that lazy allocation?

Thanks.

-- 
tejun
