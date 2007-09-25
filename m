Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXIYHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXIYHGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXIYHGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:06:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbXIYHGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:06:31 -0400
Date: Tue, 25 Sep 2007 00:06:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_NOHIGHMEM for extended crashkernel command
 line
Message-Id: <20070925000624.46bcf2b7.akpm@linux-foundation.org>
In-Reply-To: <20070925065528.GA25783@suse.de>
References: <20070925065528.GA25783@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 08:55:29 +0200 Bernhard Walle <bwalle@suse.de> wrote:

> @@ -381,6 +381,20 @@ extern unsigned long __init setup_memory
>  extern void zone_sizes_init(void);
>  #endif /* !CONFIG_NEED_MULTIPLE_NODES */
>  
> +

Only one line is needed between functions, please.

> +#ifdef CONFIG_HIGHMEM
> +static inline unsigned long long get_total_mem(void)
> +{
> +	return (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
> +}
> +#else
> +static inline unsigned long long get_total_mem(void)
> +{
> +	return max_low_pfn << PAGE_SHIFT;
> +}
> +#endif
> +
> +

Full of bugs.  (unsigned long << foo) returns an unsigned long.  With >4G
there will be truncation.

Please review the full patchset for other occurrences of this.
