Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbYHNOGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbYHNOGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYHNOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:06:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbYHNOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:06:40 -0400
Date: Thu, 14 Aug 2008 07:04:00 -0700
From: Greg KH <greg@kroah.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Pavel Machek <pavel@suse.cz>, joachim.deguara@amd.com, gregkh@ucw.cz,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 3] x86: L3 cache index disable for 2.6.26
Message-ID: <20080814140400.GA26458@kroah.com>
References: <200807181603.52332.mark.langsdorf@amd.com> <200808131502.42611.mark.langsdorf@amd.com> <20080813234503.GA32154@kroah.com> <200808140843.44090.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808140843.44090.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 08:43:43AM -0500, Mark Langsdorf wrote:
> +#if defined(CONFIG_PCI) && defined(CONFIG_K8_NB)
> +static struct pci_dev *get_k8_northbridge(int node)
> +{
> +        return k8_northbridges[node];
> +}
> +#else
> +static struct pci_dev *get_k8_northbridge(int node)
> +{
> +        return NULL;
> +}
> +#endif

This should go into the header file and not the .c file right?

It's best to keep #ifdef things in .h files.

Also, you can drop the CONFIG_K8_NB test if you do that as well, as it's
already in your .h file :)

> +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> +		unsigned int index)
> +{
> +	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	struct pci_dev *dev = get_k8_northbridge(node);
> +	unsigned int reg = 0;
> +
> +	if (!this_leaf->can_disable) 

Trailing space, did you run this through scripts/checkpatch.pl?

thanks,

greg k-h
