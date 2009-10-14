Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbZJNB6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbZJNB6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZJNB6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:58:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbZJNB6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:58:44 -0400
Date: Tue, 13 Oct 2009 18:56:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       "Alexandros C. Couloumbis" <alex@ozo.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
Message-Id: <20091013185637.870369c8.akpm@linux-foundation.org>
In-Reply-To: <20091006150737.9610.81541.stgit@localhost.localdomain>
References: <20091006150737.9610.81541.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 16:07:51 +0100 Alan Cox <alan@linux.intel.com> wrote:

> The SC1200 needs a NULL terminator or it may cause a crash on boot.
> 
> Bug #14227
> 
> Also correct a bogus comment as the driver had serializing added so can run
> dual port.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/ata/pata_sc1200.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
> index f49814d..3bbed83 100644
> --- a/drivers/ata/pata_sc1200.c
> +++ b/drivers/ata/pata_sc1200.c
> @@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
>  		.udma_mask = ATA_UDMA2,
>  		.port_ops = &sc1200_port_ops
>  	};
> -	/* Can't enable port 2 yet, see top comments */
> -	const struct ata_port_info *ppi[] = { &info, };
> +	const struct ata_port_info *ppi[] = { &info, NULL };
>  
>  	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
>  }

This patch applies to 2.6.31 and 2.6.30 (at least).  How far back
should it be ported?

There was no Cc:stable in the changelog.

There was no Cc:stable in the mail headers.  Nor cc:linux-ide.

Adding a Reported-by: is nice.

Please use the form

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14227

when mentioning bugzilla reports within changelogs.  To provide a nice
greppable pattern for those people who might close off old reports for us.

