Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0BKRRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:17:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:12582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0BKRRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:17:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,453,1262592000"; 
   d="scan'208";a="491702280"
Date: Thu, 11 Feb 2010 09:17:12 -0800 (Pacific Standard Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Matthew Garrett <mjg@redhat.com>
cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] e1000e: Only disable ASPM on 82573L devices
In-Reply-To: <1265905767-3884-1-git-send-email-mjg@redhat.com>
Message-ID: <alpine.WNT.2.00.1002110916130.6892@jbrandeb-desk1.amr.corp.intel.com>
References: <1265905767-3884-1-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Feb 2010, Matthew Garrett wrote:

> The 82537 errata and comment in e1000e_disable_l1aspm both agree that
> only 82537L devices are affected. Limit the L1 disable to them.

Hi Matthew, its a nitpick, but can you please change the part number to 
the correct one?  it should be s/82537/82573

 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/net/e1000e/netdev.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 57f149b..27eed81 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4642,6 +4642,10 @@ static void e1000e_disable_l1aspm(struct pci_dev *pdev)
>  	 * Unfortunately this feature saves about 1W power consumption when
>  	 * active.
>  	 */
> +
> +	if (pdev->device != E1000_DEV_ID_82573L)
> +		return;
> +
>  	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>  	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &val);
>  	if (val & 0x2) {
> 
