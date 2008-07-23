Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYGWGZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYGWGZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 02:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYGWGZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 02:25:26 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58314 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbYGWGZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 02:25:25 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [PATCH] sched: Test runtime rather than period in
	global_rt_runtime()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: roel kluin <roel.kluin@gmail.com>
Cc: mingo@elte.hu, rml@tech9.net, linux-kernel@vger.kernel.org
In-Reply-To: <48864843.6030808@gmail.com>
References: <488529B2.1080609@gmail.com> <1216717739.7257.94.camel@twins>
	 <48864843.6030808@gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 08:25:28 +0200
Message-Id: <1216794328.7257.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 16:51 -0400, roel kluin wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-07-21 at 20:28 -0400, roel kluin wrote:
> >> Peter, you added the test in global_rt_runtime(), in commit
> >> d0b27fa77854b149ad4af08b0fe47fe712a47ade
> >> could you take a look at it and tell whether this test should
> >> be replaced by something else?
> 
> >> -	if (sysctl_sched_rt_period < 0)
> 
> > Gah, I'm a moron. That should read:
> > 
> >   if (sysctl_sched_rt_runtime < 0)

Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> Test runtime rather than period
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 99e6d85..a73c783 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -832,7 +832,7 @@ static inline u64 global_rt_period(void)
>  
>  static inline u64 global_rt_runtime(void)
>  {
> -	if (sysctl_sched_rt_period < 0)
> +	if (sysctl_sched_rt_runtime < 0)
>  		return RUNTIME_INF;
>  
>  	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
> 

