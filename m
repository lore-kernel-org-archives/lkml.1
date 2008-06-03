Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYFCKNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYFCKNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYFCKNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:13:40 -0400
Received: from www.tglx.de ([62.245.132.106]:43801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYFCKNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:13:40 -0400
Date: Tue, 3 Jun 2008 12:13:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/7] add kernel cmdline option to disable pci-irq
 quirks
In-Reply-To: <12124107071030-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031211500.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107071030-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> From: Olaf Dabrunz <od@suse.de>
> 
> Add a switch to disable all boot interrupt quirks, using the parameter
> nobootirqquirk.

This should be a parameter in the form of

pci=ioapicquirk

and not a separate and completely unintuitive thing.

Thanks,
	tglx

> Signed-off-by: Olaf Dabrunz <od@suse.de>
> Signed-off-by: Stefan Assmann <sassmann@suse.de>
> ---
>  drivers/pci/quirks.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index dabb563..6245486 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1363,6 +1363,21 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2609, quirk_intel_pcie_pm);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
>  
> +
> +#ifdef CONFIG_X86_IO_APIC
> +int nobootirqquirk __read_mostly = 0;
> +
> +int nobootirqquirk_setup(char *str)
> +{
> +	nobootirqquirk = 1;
> +	printk(KERN_INFO "Boot IRQ quirk handling disabled\n");
> +
> +	return 1;
> +}
> +__setup("nobootirqquirk", nobootirqquirk_setup);
> +#endif /* CONFIG_X86_IO_APIC */
> +
> +
>  /*
>   * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
>   * but the PIO transfers won't work if BAR0 falls at the odd 8 bytes.
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
