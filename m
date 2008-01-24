Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYAXLPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYAXLPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYAXLPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:15:37 -0500
Received: from iona.labri.fr ([147.210.8.143]:58017 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbYAXLPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:15:36 -0500
Message-ID: <47987355.1020406@inria.fr>
Date: Thu, 24 Jan 2008 12:15:33 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Shane Huang <Shane.Huang@amd.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, htejun@gmail.com
Subject: Re: [patch] PCI: disable the MSI of AMD RS690
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shane Huang wrote:
> This patch recover Tejun's commit
> 4be8f906435a6af241821ab5b94b2b12cb7d57d8
>  because there is one MSI bug on RS690+SB600 board which will lead to
> boot failure. This bug is NOT same as the one in SB700 SATA controller,
> quirk_msi_intx_disable_bug does not work to SB600. Disablement the MSI
> of RS690 is the workaround.
> 
> diff -ruN old/drivers/pci/quirks.c new/drivers/pci/quirks.c
> --- old/drivers/pci/quirks.c	2008-01-07 05:45:38.000000000 +0800
> +++ new/drivers/pci/quirks.c	2008-01-22 11:02:00.000000000 +0800
> @@ -1623,6 +1623,7 @@
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
> PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200,
> quirk_disable_all_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480,
> quirk_disable_all_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690,
> quirk_disable_all_msi);

This patch disable MSI for the _whole_ system, not only behind the
RS690. Is this on purpose? Is MSI really going to be broken on any
bus that's _not_ behind RS690. If not, you might want to use 
quirk_disable_msi() instead (as we do for AMD8131).

Brice
