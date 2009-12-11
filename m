Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbZLKWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbZLKWNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761522AbZLKWNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:13:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761156AbZLKWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:13:17 -0500
Date: Fri, 11 Dec 2009 14:11:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Expose the irq_desc node in proc/irq
Message-Id: <20091211141158.5da226a8.akpm@linux-foundation.org>
In-Reply-To: <20091211162532.GA2716@sgi.com>
References: <20091211162532.GA2716@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 10:25:32 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> Expose the irq_desc node as /proc/irq/*/node.
> 

:(

If the changelog provides no reason for the change, the recipient has
no reason to apply the patch.

>
> ...
> +	return single_open(file, irq_node_proc_show,  PDE(inode)->data);

I'd have expected checkpatch to complain about the double-space, but it
doesn't.

> ...
>  	/* create /proc/irq/<irq>/smp_affinity */
>  	proc_create_data("smp_affinity", 0600, desc->dir,
>  			 &irq_affinity_proc_fops, (void *)(long)irq);
> +
> +	proc_create_data("node", 0444, desc->dir,
> +			 &irq_node_proc_fops, (void *)(long)irq);
>  #endif
>  
>  	proc_create_data("spurious", 0444, desc->dir,

This should be documented in Documentation/filesystems/proc.txt,
alongside smp_affinity.
