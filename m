Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZBBCJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZBBCJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZBBCJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:09:34 -0500
Received: from mail.crca.org.au ([67.207.131.56]:56652 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZBBCJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:09:34 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH 3/3] PCI PM: Make warning in
 pci_legacy_suspend more useful
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902012234.25165.rjw@sisk.pl>
References: <200902012229.27517.rjw@sisk.pl>
	 <200902012234.25165.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 02 Feb 2009 13:10:01 +1100
Message-Id: <1233540601.21871.10.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On Sun, 2009-02-01 at 22:34 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The warning in pci_legacy_suspend() would be much more useful if it
> printed the name of the function that did the wrong thing.  Make it
> do so.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -365,7 +365,9 @@ static int pci_legacy_suspend(struct dev
>  		if (pci_dev->state_saved)
>  			goto Fixup;
>  
> -		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> +		if (WARN_ONCE(pci_dev->current_state != PCI_D0,
> +				"PCI PM: Device state not saved by %pF\n",
> +				drv->suspend))
>  			goto Fixup;
>  	}

Am I right in thinking that WARN_ONCE will only warn about the first
driver that has the problem? If so, wouldn't it be better to make it
warn about all drivers that have the problem, but only once per device?

Regards,

Nigel

