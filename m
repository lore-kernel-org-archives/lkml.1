Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYGNRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYGNRSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYGNRRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:17:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757846AbYGNRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:17:46 -0400
Date: Mon, 14 Jul 2008 10:17:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] genirq updates for 2.6.27
Message-Id: <20080714101722.e0df1608.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141822470.3283@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807141822470.3283@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 18:27:22 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:

> Linus,
> 
> Please pull the latest genirq git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git genirq
> 

Could you cc me on the pull requests please?  I _do_ look them over,
but I'm often days behind in my lkml reading.

> +void register_default_affinity_proc(void)
> +{
> +#ifdef CONFIG_SMP
> +	struct proc_dir_entry *entry;
> +
> +	/* create /proc/irq/default_smp_affinity */
> +	entry = create_proc_entry("default_smp_affinity", 0600, root_irq_dir);
> +	if (entry) {
> +		entry->data = NULL;
> +		entry->read_proc  = default_affinity_read;
> +		entry->write_proc = default_affinity_write;
> +	}
> +#endif
> +}

This should have static scope.
