Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0CDVRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:17:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340Ab0CDVRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:17:38 -0500
Date: Thu, 4 Mar 2010 13:17:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <bhavna.sarathy@amd.com>, <joachim.deguara@amd.com>
Subject: Re: [PATCH 1/3] [cpufreq] [retry 1] Add APERF/MPERF support for AMD
 processors
Message-Id: <20100304131734.7e3fb7f4.akpm@linux-foundation.org>
In-Reply-To: <201003031456.56205.mark.langsdorf@amd.com>
References: <201003031456.56205.mark.langsdorf@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 14:56:56 -0600
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> +unsigned int get_measured_perf(struct cpufreq_policy *policy,
> +					unsigned int cpu)
> +{
> +	struct aperfmperf perf;
> +	unsigned long ratio;
> +	unsigned int retval;
> +
> +	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
> +		return 0;
> +
> +	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
> +	per_cpu(acfreq_old_perf, cpu) = perf;
> +
> +	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
> +
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(get_measured_perf);

That's a pretty crappy name for a kernel-wide identifier. 
cpufreq_get_measured_perf() would be typical and better.
