Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYAJTJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYAJTJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbYAJTIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:08:43 -0500
Received: from ns.suse.de ([195.135.220.2]:51053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760045AbYAJTIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:08:42 -0500
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.co, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 09/11] PAT x86: Add ioremap_wc support
From: Andi Kleen <andi@firstfloor.org>
References: <20080110184840.927409000@intel.com>
	<20080110184856.379082000@intel.com>
Date: Thu, 10 Jan 2008 20:08:40 +0100
In-Reply-To: <20080110184856.379082000@intel.com> (venkatesh pallipadi's message of "Thu\, 10 Jan 2008 10\:48\:49 -0800")
Message-ID: <p733at5o5vr.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:
> Index: linux-2.6.git/include/asm-generic/iomap.h
> ===================================================================
> --- linux-2.6.git.orig/include/asm-generic/iomap.h	2008-01-08 03:31:37.000000000 -0800
> +++ linux-2.6.git/include/asm-generic/iomap.h	2008-01-08 05:15:56.000000000 -0800
> @@ -65,4 +65,8 @@
>  extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
>  extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
>  
> +#ifndef ioremap_wc
> +#define ioremap_wc ioremap_nocache
> +#endif

I don't think that's a good idea. Drivers should be able to detect this somehow.
Handling UC mappings as WC will probably give very poor results.

-Andi
