Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYI2SSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYI2SSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYI2SR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:17:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYI2SRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:17:55 -0400
Message-ID: <48E11BBE.3080709@zytor.com>
Date: Mon, 29 Sep 2008 11:17:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
References: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
In-Reply-To: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The flag_is_changeable_p() is used by
> has_cpuid_p() which can return different results
> in the code sequence below:
> 
>  if (!have_cpuid_p())
>       identify_cpu_without_cpuid(c);
> 
>   /* cyrix could have cpuid enabled via c_identify()*/
>   if (!have_cpuid_p())
>       return;
> 
> Otherwise, the gcc 3.4.6 optimizes these two calls
> into one which make the code not working correctly.
> Cyrix cpus have the CPUID instruction enabled but
> it is not detected due to the gcc optimization.
> Thus the ARR registers (mtrr like) are not detected
> on such a cpu.
> 

I suspect we should also out-of-line this function.  It's actually 
relatively sizable and certainly there is no point in inlining it.

	-hpa
