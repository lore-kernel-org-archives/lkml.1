Return-Path: <linux-kernel-owner+w=401wt.eu-S935554AbZAPOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935554AbZAPOKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934969AbZAPOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:10:19 -0500
Received: from rtr.ca ([76.10.145.34]:35185 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934477AbZAPOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:10:17 -0500
Message-ID: <49709547.7060001@rtr.ca>
Date: Fri, 16 Jan 2009 09:10:15 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <496D8CEB.5060402@zytor.com>	<20090114093834.GA19799@elte.hu>	<496F0F50.6070200@kernel.org>	<20090115113045.GG22850@elte.hu>	<496F2032.5080502@kernel.org>	<20090115122611.GJ22850@elte.hu>	<496F346B.6020804@kernel.org>	<20090115130740.GE21839@elte.hu>	<496F38C7.5000403@kernel.org>	<20090115093007.4215b4b4.akpm@linux-foundation.org>	<20090115180259.GJ22472@elte.hu> <20090115103406.a85968f0.akpm@linux-foundation.org>
In-Reply-To: <20090115103406.a85968f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Jan 2009 19:02:59 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
..
>>> I wonder if the preempt_disable()/preempt_enable() in here actually
>>> does anything useful on any architecture.
>> Provides "this is IRQ safe"
> 
> ?
> 
>> and "this is preempt safe" semantics.
> 
> Of course.  But do any architectures actually _need_ that for a single read?
..

If the target is unaligned, then RISC architectures will need protection there.
If we can guarantee correct memory alignment of the target, then no / none.

Cheers
