Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZBDBzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZBDBzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZBDBzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:55:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:54480 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZBDBzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:55:37 -0500
Subject: Re: [PATCH 2/7] PCI PM: Check if the state has been saved before
 trying to restore it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
In-Reply-To: <200902040157.23385.rjw@sisk.pl>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040157.23385.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 12:54:26 +1100
Message-Id: <1233712466.16867.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 01:57 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Check if the standard configuration registers of a PCI device have
> been saved during suspend before trying to restore them during
> resume.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-By: Benjamin Herrenschmidt <benh@kernel.crashing.org>


> ---
>  drivers/pci/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1421,7 +1421,7 @@ int pci_restore_standard_config(struct p
>  	dev->current_state = PCI_D0;
>  
>   Restore:
> -	return pci_restore_state(dev);
> +	return dev->state_saved ? pci_restore_state(dev) : 0;
>  }
>  
>  /**

