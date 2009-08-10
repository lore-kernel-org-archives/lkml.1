Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbZHJQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbZHJQaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZHJQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:30:24 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:35187 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932092AbZHJQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:30:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OddEok2ApUk3qTXnRg7iIZuo0IcbnNnsIPONH5f0oDagfw/axGI7fBH++57otRRh1UfvxpyHht4/IDt7RdyIly2lH16PJVXYIrnqQzvBTRicXlUjhQK5hv1r2b2/kjpG;
Date: Mon, 10 Aug 2009 09:30:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] pci: dmar/intr_remapping/iov use physfn to search drhd
Message-ID: <20090810093022.710a09f8@jbarnes-g45>
In-Reply-To: <4A785A57.8050505@kernel.org>
References: <4A785A57.8050505@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Dave.

On Tue, 04 Aug 2009 08:57:11 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> when virtfn is used, we should use physfn to find correct drhd
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/dmar.c           |    5 +++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/dmar.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/dmar.c
> +++ linux-2.6/drivers/pci/dmar.c
> @@ -493,6 +493,11 @@ dmar_find_matched_drhd_unit(struct pci_d
>  	struct dmar_drhd_unit *dmaru = NULL;
>  	struct acpi_dmar_hardware_unit *drhd;
>  
> +#ifdef CONFIG_PCI_IOV
> +	if (dev->is_virtfn)
> +		dev = dev->physfn;
> +#endif
> +
>  	list_for_each_entry(dmaru, &dmar_drhd_units, list) {
>  		drhd = container_of(dmaru->hdr,
>  				    struct acpi_dmar_hardware_unit,
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
