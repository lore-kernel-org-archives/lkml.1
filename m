Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbYBVERp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbYBVERp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYBVERf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:17:35 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59881 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYBVERe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:17:34 -0500
Date: Thu, 21 Feb 2008 21:17:33 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Crane Cai <crane.cai@amd.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
Message-ID: <20080222041733.GD16995@parisc-linux.org>
References: <20080221234644.GA7128@kroah.com> <1203637660-7247-3-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203637660-7247-3-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 03:47:33PM -0800, Greg Kroah-Hartman wrote:
> +static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
>  {
> -	/* set sb600 sata to ahci mode */
> -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> -		u8 tmp;
> +	/* set sb600/sb700/sb800 sata to ahci mode */
> +	u8 tmp;
>  
> +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> +	if (tmp == 0x01) {
>  		pci_read_config_byte(pdev, 0x40, &tmp);

This seems like a dis-improvement.  Why are we reading a config byte for
something we already have in the pci_dev?  Why are we now checking
against 0x01 instead of a symbolic constant?  Why are we no longer
checking that this is PCI_BASE_CLASS_STORAGE?

> -DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
> -DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);

Nothing in the changelog entry suggests why we now need FIXUP_RESUME
entries when we didn't before.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
