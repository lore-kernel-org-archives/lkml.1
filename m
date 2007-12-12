Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXLLLdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXLLLdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXLLLdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:33:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbXLLLdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:33:39 -0500
Date: Wed, 12 Dec 2007 03:33:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/47] Update and improve CRISv32 kernel/time.c
Message-Id: <20071212033325.5382fe3a.akpm@linux-foundation.org>
In-Reply-To: <16367c7dcde15b42e831549e14f1d03439cc02b0.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<16367c7dcde15b42e831549e14f1d03439cc02b0.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 17:25:45 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> +#ifdef CONFIG_CPU_FREQ
> +	cpufreq_register_notifier(&cris_time_freq_notifier_block,
> +		CPUFREQ_TRANSITION_NOTIFIER);
>  #endif

include/linux/cpufreq.h has

#ifdef CONFIG_CPU_FREQ
...
#else		/* CONFIG_CPU_FREQ */
static inline int cpufreq_register_notifier(struct notifier_block *nb,
						unsigned int list)
{
	return 0;
}


the idea is that you remove the above ifdefs and also the ifdefs around
cris_time_freq_notifier_block and then gcc magically removes
cris_time_freq_notifier_block from your generated code.

Advantages: no ifdefs, and full typechecking even when CONFIG_CPU_FREQ=n.


cpufreq_register_notifier() can fail but this code pretends otherwise...
