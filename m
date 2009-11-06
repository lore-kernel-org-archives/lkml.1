Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbZKFQKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbZKFQKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbZKFQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:10:33 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:39579 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759381AbZKFQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:10:32 -0500
Date: Fri, 6 Nov 2009 11:08:50 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
In-Reply-To: <4AF3E3D1.7010101@kernel.org>
Message-ID: <alpine.DEB.1.10.0911061108120.3453@V090114053VZO-1>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org>
 <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu> <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu> <4AF3E3D1.7010101@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Tejun Heo wrote:

> Ingo Molnar wrote:
> > My question is, why do we do flags save/restore in pcpu-alloc?
>
> That's strictly for calls from sched_init().

Right its a hack for 2.6.32. Fix it the right way by making the per cpu
allocator take gfp flags like any other allocator in the kernel.
