Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZG0UrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZG0UrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZG0UrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:47:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbZG0UrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:47:23 -0400
Message-ID: <4A6E1222.5010709@zytor.com>
Date: Mon, 27 Jul 2009 13:46:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com> <4A526D38.7000803@zytor.com> <20090707103723.GD5668@aftab> <4A537010.3050905@zytor.com> <20090708111911.GC19315@aftab>
In-Reply-To: <20090708111911.GC19315@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>  
>  	preempt_disable();
> -	/*
> -	 * FIXME: handle the CPU we're executing on separately for now until
> -	 * smp_call_function_many has been fixed to not skip it.
> -	 */
>  	this_cpu = raw_smp_processor_id();
> -	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
>  
> -	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
> +	if (cpumask_test_cpu(this_cpu, mask))
> +		msr_func(&rv);
> +
> +	smp_call_function_many(mask, msr_func, &rv, 1);
>  	preempt_enable();
>  }

Any reason not to use get_cpu() ... put_cpu() instead?

	-hpa
