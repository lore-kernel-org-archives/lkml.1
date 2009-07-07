Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZGGP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZGGP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZGGP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:58:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZGGP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:58:08 -0400
Message-ID: <4A537010.3050905@zytor.com>
Date: Tue, 07 Jul 2009 08:56:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: remove code duplication
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com> <4A526D38.7000803@zytor.com> <20090707103723.GD5668@aftab>
In-Reply-To: <20090707103723.GD5668@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> Actually, the more important question is why am I executing anything on
> my own CPU without first checking if it is in the cpumask _at_ _all_?!
> /me ducks behind the sofa.
> 
> The right thing to do should be something like the following:
> 
> preempt_disable();
> this_cpu = raw_smp_processor_id();
> 
> if (cpumask_test_cpu(this_cpu, mask)) {
> 	local_irq_disable();
> 	msr_func(&rv);
> 	local_irq_enable();
> }
> 
> smp_call_function_many(mask, msr_func, &rv, 1);
> preempt_enable();
> 

I don't see why you're disabling local IRQs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

