Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYHGP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYHGP4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYHGP4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:56:39 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:42146 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752335AbYHGP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:56:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=SNNwW8B2M3ANQbRyA75YM2X7z6x7/8IzgX1QcV/kVlxrGvAIIoTjD2wg/SNQdQ2D4vKvDAjkIvFxOmuB1YjNAsEQqqC+6CmMGXV+hXWPoP50623eu+cK5VMb9x4KqlEb;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dean Hildebrand <seattleplus@gmail.com>
Subject: Re: PCI: Limit VPD length for Broadcom 5708S
Date: Thu, 7 Aug 2008 08:56:34 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <aVL4E-5C9-7@gated-at.bofh.it> <2d9716d7-99a4-4d17-9cae-83842e216c8c@y19g2000prn.googlegroups.com> <4898A0B2.3070201@gmail.com>
In-Reply-To: <4898A0B2.3070201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070856.34679.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 5, 2008 11:49 am Dean Hildebrand wrote:
> > I have no idea if 5706S and 5709S also needs this truncation ofVPDlength
>
> It seems that our IBM Blade servers using 5706S also require this
> fix.  We have confirmed that the patch below works on 2.6.27-rc1.
>
>
> diff -uprN linux-2.6.27-rc1/drivers/pci/quirks.c
> linux-2.6.27-rc1-fix/drivers/pci/quirks.c
> --- linux-2.6.27-rc1/drivers/pci/quirks.c       2008-08-05
> 10:51:42.000000000 -0700
> +++ linux-2.6.27-rc1-fix/drivers/pci/quirks.c   2008-08-05
> 10:50:57.000000000 -0700
> @@ -1756,9 +1756,10 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VI
>    */
>   static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
>   {
> -       /*  Only disable the VPD capability for 5706, 5708, and 5709
> rev. A */
> +       /*  Only disable the VPD capability for 5706, 5706S, 5708, and
> 5709 rev. A */
>          if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
>              (dev->device == PCI_DEVICE_ID_NX2_5708) ||
> +           (dev->device == PCI_DEVICE_ID_NX2_5706S) ||
>              ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
>               (dev->revision & 0xf0) == 0x0)) {
>                  if (dev->vpd)

Looks fine.  Can you respin against my for-linus branch and resubmit with a 
signed-off-by and full changelog?

Thanks,
Jesse
