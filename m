Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYFXFxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYFXFxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYFXFxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:53:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYFXFxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:53:39 -0400
Date: Mon, 23 Jun 2008 22:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: VT3336 can't do MSI either
Message-Id: <20080623225302.ab7b35de.akpm@linux-foundation.org>
In-Reply-To: <48608792.7090909@kernel.org>
References: <48608792.7090909@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 14:35:14 +0900 Tejun Heo <tj@kernel.org> wrote:

> It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
> Reported in the following SUSE bug.
> 
>   https://bugzilla.novell.com/show_bug.cgi?id=300001
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

(argh.  Is that permanent(ish)?)

> ---
> Anyone interested in queuing this for -rc8?  Thanks.

Strictly a Jesse thing I guess, but I can do it ujnless there be objections.

> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index dabb563..9d95f0b 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1685,6 +1685,7 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
>  
>  /* Disable MSI on chipsets that are known to not support it */
