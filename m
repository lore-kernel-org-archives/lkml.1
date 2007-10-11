Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXJKVxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXJKVxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXJKVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:53:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58319 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXJKVxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:53:47 -0400
Date: Thu, 11 Oct 2007 14:40:28 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] X86: Introduce and enable PCI domain support
Message-ID: <20071011214028.GC32752@kroah.com>
References: <20071011205727.GA29222@havoc.gtf.org> <20071011205830.GB29376@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011205830.GB29376@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 04:58:30PM -0400, Jeff Garzik wrote:
> 
> * fix bug in pci_read() and pci_write() which prevented PCI domain
>   support from working (hardcoded domain 0).
> 
> * unconditionally enable CONFIG_PCI_DOMAINS
> 
> * implement pci_domain_nr() and pci_proc_domain(), as required of
>   all arches when CONFIG_PCI_DOMAINS is enabled.
> 
> * store domain in struct pci_sysdata, as assigned by ACPI
> 
> * support "pci=nodomains"
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Revised per Andi's comments, and split into two patches.

Ugh:
	In file included from include/linux/pci.h:785,
	                 from drivers/pci/access.c:2:
	include/asm/pci.h:16: error: redefinition of 'pci_domain_nr'
	include/linux/pci.h:692: error: previous definition of 'pci_domain_nr' was here
	include/asm/pci.h:22: error: redefinition of 'pci_proc_domain'
	include/linux/pci.h:694: error: previous definition of 'pci_proc_domain' was here
	make[1]: *** [drivers/pci/access.o] Error 1

I'll see if I can fix it up...

thanks,

greg k-h
