Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXJXXdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXJXXdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXJXXdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:33:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbXJXXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:33:30 -0400
Date: Wed, 24 Oct 2007 16:33:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Neuling <mikey@neuling.org>
Cc: paulus@samba.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] taskstats scaled time cleanup
Message-Id: <20071024163305.14b9bfba.akpm@linux-foundation.org>
In-Reply-To: <8789.1193208897@neuling.org>
References: <8789.1193208897@neuling.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 16:54:57 +1000
Michael Neuling <mikey@neuling.org> wrote:

> +/* Estimate the scaled cputime by scaling the real cputime based on
> + * the last scaled to real ratio */
> +static inline cputime_t cputime_to_scaled(const cputime_t ct)
> +{
> +	if (cpu_has_feature(CPU_FTR_SPURR) &&
> +	    per_cpu(cputime_last_delta, smp_processor_id()))
> +		return ct *
> +			per_cpu(cputime_scaled_last_delta, smp_processor_id())/
> +			per_cpu(cputime_last_delta, smp_processor_id());
> +	return ct;
> +}

This looks far too large to be inlined.
