Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZFIPso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZFIPso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZFIPsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:48:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbZFIPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:48:36 -0400
Date: Tue, 9 Jun 2009 08:46:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
In-Reply-To: <200906091627.45411.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain>
References: <4A2835D8.6040903@kernel.org> <4A2AE4AC.60805@kernel.org> <4A2AE570.2010307@kernel.org> <200906091627.45411.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Rusty Russell wrote:
>  
>  	for_each_online_cpu(i) {
> -		if (check_supported_cpu(i))
> +		if (work_on_cpu(i, check_supported_cpu, NULL) == 0)
>  			supported_cpus++;

Please STOP USING THAT HORRIBLE "work_on_cpu()" crap.

Is there any reason you do that? We've had to fix up the fallout from that 
kind of crazy crap several times.

Just use a regular IPI. Use "smp_call_function_[single|many]()" instead.

See for example commit 01599fca6758d2cd133e78f87426fc851c9ea725, where 
another "work_on_cpu()" thing was broken.

I don't understand why you guys keep on using that _known_ bad function. 
The whole point of "work_on_cpu()" is for big, slow, and rare things. Not 
as a random "let's make that CPU do this".

So stop it. 

			Linus
