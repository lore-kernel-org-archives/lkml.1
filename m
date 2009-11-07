Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZKGQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZKGQNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZKGQNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:13:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZKGQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:13:53 -0500
Subject: Re: irq lock inversion
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0911061159450.5187@V090114053VZO-1>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com>
	 <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu>
	 <4AF28D7A.6020209@kernel.org>
	 <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>
	 <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu>
	 <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu>
	 <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu>
	 <4AF3E3D1.7010101@kernel.org>
	 <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>
	 <4AF45109.7070503@kernel.org>
	 <alpine.DEB.1.10.0911061159450.5187@V090114053VZO-1>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 17:13:32 +0100
Message-ID: <1257610412.4108.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 12:03 -0500, Christoph Lameter wrote:
> Atomic allocs are allowed to fail.

All allocs (except __GFP_NOFAIL, but those are a deadlock waiting to
happen) are allowed to fail, !__GFP_WAIT allocs simply fail more easily.

The fact that __GFP_WAIT && order <= PAGE_ALLOC_COSTLY_ORDER allocations
currently don't fail but keep hammering the allocator could be
considered a bug (the recent OOM threads in fact suggest this is a
serious issue for some people).

