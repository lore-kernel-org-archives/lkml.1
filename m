Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZKFWAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZKFWAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZKFWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:00:22 -0500
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:45614 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758688AbZKFWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:00:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A+G+AiVX9qt0TrPPJ9ih9ufv3HldrHFOy7uHWL8nfzMPXqD0EsZpvdn1qAKMZjKDz5DqRrjvckklWc7z1D26bq9HpOqa0kMVNrEhZ4MGU9NHrIEtQMw9ApSfSAsdJtgJ;
Date: Fri, 6 Nov 2009 14:00:28 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Message-ID: <20091106140028.6242cb94@jbarnes-piketon>
In-Reply-To: <4AF240E7.8050200@jp.fujitsu.com>
References: <19184.41676.262206.134000@gargle.gargle.HOWL>
	<20091104110321.5e58e112@jbarnes-piketon>
	<200911041628.17905.bjorn.helgaas@hp.com>
	<4AF240E7.8050200@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Nov 2009 12:05:11 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
> There are a lot of codes that searches PCI express capability offset
> in the PCI configuration space using pci_find_capability(). Caching it
> in the struct pci_dev will reduce unncecessary search. This patch adds
> an additional 'pcie_cap' fields into struct pci_dev, which is
> initialized at pci device scan time (in set_pcie_port_type()).
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/probe.c |    1 +
>  include/linux/pci.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> Index: 20090825/drivers/pci/probe.c
> ===================================================================
> --- 20090825.orig/drivers/pci/probe.c
> +++ 20090825/drivers/pci/probe.c
> @@ -693,6 +693,7 @@ static void set_pcie_port_type(struct pc
>  	if (!pos)
>  		return;
>  	pdev->is_pcie = 1;
> +	pdev->pcie_cap = pos;
>  	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
>  	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
>  }
> Index: 20090825/include/linux/pci.h
> ===================================================================
> --- 20090825.orig/include/linux/pci.h
> +++ 20090825/include/linux/pci.h
> @@ -218,6 +218,7 @@ struct pci_dev {
>  	unsigned int	class;		/* 3 bytes:
> (base,sub,prog-if) */ u8		revision;	/* PCI
> revision, low byte of class word */ u8
> hdr_type;	/* PCI header type (`multi' flag masked out) */
> +	u8		pcie_cap;	/* PCI-E capability
> offset */ u8		pcie_type;	/* PCI-E device/port
> type */ u8		rom_base_reg;	/* which config
> register controls the ROM */ u8		pin;
> 		/* which interrupt pin this device uses */
> 
> 

Applied this one to linux-next, thanks Kenji-san.

-- 
Jesse Barnes, Intel Open Source Technology Center
