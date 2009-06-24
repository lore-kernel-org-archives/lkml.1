Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbZFXQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbZFXQjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZFXQjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:39:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33327 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZFXQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:39:12 -0400
Message-ID: <4A4256AD.3080507@austin.ibm.com>
Date: Wed, 24 Jun 2009 11:39:09 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Gautham R Shenoy <ego@in.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH] pseries: cpu: Reduce the polling interval in __cpu_up()
References: <20090624092637.32078.88042.stgit@sofia.in.ibm.com>
In-Reply-To: <20090624092637.32078.88042.stgit@sofia.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The code needs testing on other powerpc platforms.
>   
I think given the numbers you showed this is a good improvement, and it 
clearly can't do any harm on platforms that implement msleep correctly.

For what it's worth:
Acked-by: Joel Schopp <jschopp@austin.ibm.com>
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  arch/powerpc/kernel/smp.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 65484b2..00c13a1 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -411,9 +411,8 @@ int __cpuinit __cpu_up(unsigned int cpu)
>  		 * CPUs can take much longer to come up in the
>  		 * hotplug case.  Wait five seconds.
>  		 */
> -		for (c = 25; c && !cpu_callin_map[cpu]; c--) {
> -			msleep(200);
> -		}
> +		for (c = 5000; c && !cpu_callin_map[cpu]; c--)
> +			msleep(1);
>  #endif
>  
>  	if (!cpu_callin_map[cpu]) {
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>   

