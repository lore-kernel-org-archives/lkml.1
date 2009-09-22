Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZIVXSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZIVXSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZIVXSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:18:07 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56514 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbZIVXSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:18:06 -0400
Date: Tue, 22 Sep 2009 18:59:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu
 areas for other cpus
In-Reply-To: <1253605214-23210-3-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1>
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Tejun Heo wrote:

>
> +#ifdef	CONFIG_SMP
> +  . = ALIGN(PERCPU_PAGE_SIZE);
> +  __cpu0_per_cpu = .;

__per_cpu_start?

> +  . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
> +#endif

This is a statically sized per cpu area that is used by __get_cpu_var()
Data is access via a cpu specific memory mapping. How does this work when
the area grows beyond  PERCPU_PAGE_SIZE? As far as I can see: It seems
that __get_cpu_var would then cause a memory fault?
