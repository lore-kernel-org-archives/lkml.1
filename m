Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXGLAMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXGLAMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936966AbXGLABw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:01:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45823 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935715AbXGLABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:01:51 -0400
Date: Wed, 11 Jul 2007 18:01:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James.Smart@Emulex.Com
Subject: Re: [Pcihpd-discuss] [PATCH 26/34] PCI: add pci_try_set_mwi
Message-ID: <20070712000149.GX9704@parisc-linux.org>
References: <11841968053873-git-send-email-gregkh@suse.de> <11841968092270-git-send-email-gregkh@suse.de> <11841968133805-git-send-email-gregkh@suse.de> <11841968172168-git-send-email-gregkh@suse.de> <11841968221388-git-send-email-gregkh@suse.de> <11841968302709-git-send-email-gregkh@suse.de> <11841968341206-git-send-email-gregkh@suse.de> <11841968561560-git-send-email-gregkh@suse.de> <11841968591561-git-send-email-gregkh@suse.de> <11841968633587-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11841968633587-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 04:31:40PM -0700, Greg Kroah-Hartman wrote:
> As suggested by Andrew, add pci_try_set_mwi(), which does not require
> return-value checking.

Seems like a daft suggestion.  What's wrong with just removing the
__must_check from pci_set_mwi()?  Did it find any bugs?

> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1578,10 +1578,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
>  	INIT_LIST_HEAD(&phba->fc_nodes);
>  
>  	pci_set_master(pdev);
> -	retval = pci_set_mwi(pdev);
> -	if (retval)
> -		dev_printk(KERN_WARNING, &pdev->dev,
> -			   "Warning: pci_set_mwi returned %d\n", retval);
> +	pci_try_set_mwi(pdev);

Why remove the warning?  Presumably people want to know if pci_set_mwi
failed.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
