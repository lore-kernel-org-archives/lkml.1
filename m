Return-Path: <linux-kernel-owner+w=401wt.eu-S1030604AbXAZCWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604AbXAZCWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030617AbXAZCWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:22:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030604AbXAZCWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:22:04 -0500
Message-ID: <45B965C6.5090604@pobox.com>
Date: Thu, 25 Jan 2007 21:21:58 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-ide@vger.kernel.org, kay.sievers@suse.de,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove duplicate ids from ata_piix
References: <20070126021228.GA3444@kroah.com>
In-Reply-To: <20070126021228.GA3444@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> It seems that the ata_piix driver has two duplicate ids, one of them
> with a different 'private' field in it, which was never being used due
> to the match for the device happening on an earlier entry.
> 
> This patch removes the duplicates, if this is the correct thing to do in
> this case for the ICH5 device or not, I'll leave to you :)
> 
> This duplication was pointed out to me by Kay Sievers <kay.sievers@suse.de>
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/ata/ata_piix.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> --- gregkh-2.6.orig/drivers/ata/ata_piix.c
> +++ gregkh-2.6/drivers/ata/ata_piix.c
> @@ -191,12 +191,8 @@ static const struct pci_device_id piix_p
>  	/* Intel ICH4 (i845GV, i845E, i852, i855) UDMA 100 */
>  	{ 0x8086, 0x24CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
>  	{ 0x8086, 0x24CB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
> -	/* Intel ICH5 */
> -	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
>  	/* C-ICH (i810E2) */
>  	{ 0x8086, 0x245B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
> -	/* ESB (855GME/875P + 6300ESB) UDMA 100  */
> -	{ 0x8086, 0x25A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
>  	/* ICH6 (and 6) (i915) UDMA 100 */
>  	{ 0x8086, 0x266F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
>  	/* ICH7/7-R (i945, i975) UDMA 100*/

Both IDs are clearly dups, but ICH5 should support ich_pata_133, so 
you're removing the wrong entry there.

I think the right thing to do is remove the entries that appear near the 
top of the list, but I would like Alan (Mr. PATA) to confirm...

	/* Also PIIX4E (fn3 rev 2) and PIIX4M (fn3 rev 3) */
	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
-	{ 0x8086, 0x24db, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-	{ 0x8086, 0x25a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },

Regards,

	Jeff


