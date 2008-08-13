Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYHMXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYHMXze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYHMXzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:55:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbYHMXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:55:04 -0400
Date: Wed, 13 Aug 2008 16:45:03 -0700
From: Greg KH <greg@kroah.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Pavel Machek <pavel@suse.cz>, joachim.deguara@amd.com, gregkh@ucw.cz,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 2] x86: L3 cache index disable for 2.6.26
Message-ID: <20080813234503.GA32154@kroah.com>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz> <20080812221201.GA3550@kroah.com> <200808131502.42611.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131502.42611.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 03:02:42PM -0500, Mark Langsdorf wrote:
> +#if defined(CONFIG_PCI) && defined(CONFIG_K8_NB)
> +#include <linux/pci.h>

Not needed to be hid behind a #if.

> +#include <asm/k8.h>

#includes go at the top of files.

> +static struct pci_dev *get_k8_northbridge(int node)
> +{
> +        return k8_northbridges[node];
> +}
> +#else
> +static inline int pci_write_config_dword(struct pci_dev *dev, int where,
> +                                         u32 val)

Don't redefine these common functions, pci.h will handle this properly
if for some reason CONFIG_PCI is not enabled.

thanks,

greg k-h
