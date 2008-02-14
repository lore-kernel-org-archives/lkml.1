Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYBNVeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYBNVeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYBNVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:33:50 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57714 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYBNVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:33:49 -0500
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080212234928.GA13892@havoc.gtf.org>
References: <20080212234928.GA13892@havoc.gtf.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 15:33:42 -0600
Message-Id: <1203024822.3158.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 18:49 -0500, Jeff Garzik wrote:
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Nice work, thanks.  This is PCI only I take it.  ISA and EISA look like
they'll be a tad more troublesome, so PCI only is fine.

> ---
>  drivers/scsi/gdth.c |  143 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 86 insertions(+), 57 deletions(-)
> 
> 06196f50915da97bb897495863f9f084d785c1e4
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index c825239..1b53e92 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -595,85 +595,107 @@ static int __init gdth_search_isa(ulong32 bios_adr)
>  #endif /* CONFIG_ISA */
>  
>  #ifdef CONFIG_PCI
> -static void gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
> -                            ushort vendor, ushort dev);
> +static gdth_pci_str gdth_pcistr[MAXHA];
> +static int gdth_pci_cnt;
> +static bool gdth_pci_registered;

Could we get rid of these static arrays and MAXHA entirely?  It should
be possible just to bung the parameters in pci_str into gdth_ha_str and
dump the arrays.

Thanks,

James


