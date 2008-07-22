Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYGVJJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYGVJJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGVJJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:09:06 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:51307 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYGVJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:09:05 -0400
Subject: Re: [PATCH 1/9] sched: test below 0 on unsigned
	sysctl_sched_rt_period
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: roel kluin <roel.kluin@gmail.com>
Cc: mingo@elte.hu, rml@tech9.net, linux-kernel@vger.kernel.org
In-Reply-To: <488529B2.1080609@gmail.com>
References: <488529B2.1080609@gmail.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 11:08:59 +0200
Message-Id: <1216717739.7257.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 20:28 -0400, roel kluin wrote:
> Peter, you added the test in global_rt_runtime(), in commit
> d0b27fa77854b149ad4af08b0fe47fe712a47ade
> could you take a look at it and tell whether this test should
> be replaced by something else?
> 
> The patch was only checkpatch tested
> ---
> sysctl_sched_rt_period is unsigned so the test doesn't work.
> state_filter is an unsigned long so the test didn't work
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 99e6d85..2030340 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -832,9 +832,6 @@ static inline u64 global_rt_period(void)
>  
>  static inline u64 global_rt_runtime(void)
>  {
> -	if (sysctl_sched_rt_period < 0)
> -		return RUNTIME_INF;

Gah, I'm a moron. That should read:

  if (sysctl_sched_rt_runtime < 0)

Care to send a patch to fix it?

Thanks for spotting this!


