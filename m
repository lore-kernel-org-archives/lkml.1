Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYKFCw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYKFCw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYKFCwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:52:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYKFCwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:52:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 7/7] cpu alloc: page allocator conversion
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20081105231650.526116017@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081105231650.526116017@quilx.com>
Message-Id: <20081106115113.0D38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 11:52:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_SMP
>  static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
>  		unsigned long action,
>  		void *hcpu)
> @@ -2800,14 +2746,7 @@
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> -		if (process_zones(cpu))
> -			ret = NOTIFY_BAD;
> -		break;
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> -		free_zone_pagesets(cpu);
> +		process_zones(cpu);
>  		break;

Why do you drop cpu unplug code?



