Return-Path: <linux-kernel-owner+w=401wt.eu-S1751163AbZKZFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbZKZFNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZKZFNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:13:23 -0500
Received: from ozlabs.org ([203.10.76.45]:44666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZKZFNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:13:22 -0500
Date: Thu, 26 Nov 2009 16:10:36 +1100
From: Anton Blanchard <anton@samba.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5 2/4] pSeries: Add hooks to put the CPU into an
 appropriate offline state
Message-ID: <20091126051036.GA12086@kryten>
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
 <20091030052253.25493.65063.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030052253.25493.65063.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Gautham,

> +	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
> +				NULL,
> +				CEDE_LATENCY_TOKEN,
> +				__pa(cede_parameters),
> +				CEDE_LATENCY_PARAM_MAX_LENGTH);
> +
> +	if (call_status != 0)
> +		printk(KERN_INFO "CEDE_LATENCY: \
> +			%s %s Error calling get-system-parameter(0x%x)\n",
> +			__FILE__, __func__, call_status);
> +	else
> +		printk(KERN_INFO "CEDE_LATENCY: \
> +			get-system-parameter successful.\n");

I'm seeing this on a POWER6 box:


CEDE_LATENCY: 			arch/powerpc/platforms/pseries/hotplug-cpu.c parse_cede_parameters Error calling get-system-parameter(0xfffffffd)


Seems overly verbose. Do we need to print success/fail on this call? Perhaps
a summary line if anything during initialisation failed:

Cede latency not supported

and

Cede latency supported

If it all worked.

Anton
