Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYIQW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYIQW2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYIQW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:28:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7517 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIQW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:28:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 3/6] pci: using printk(KERN_PCI v3
Date: Wed, 17 Sep 2008 16:28:05 -0600
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171628.05689.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 02:27:44 am Yinghai Lu wrote:
> v2: use printk(KERN_DEBUG KERN_PCI ...
> v3: fix checkpatch error and warning
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/pci/probe.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -304,7 +304,8 @@ static int __pci_read_base(struct pci_de
>  		} else {
>  			res->start = l64;
>  			res->end = l64 + sz64;
> -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> +			printk(KERN_DEBUG KERN_PCI
> +				 "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>  				 pci_name(dev), pos, res->start, res->end);

I really don't understand the point of this series.  I think
the user experience is too confusing.

But if you're going to change printks like the one above,
please at least make it use dev_printk() like most of the
rest of the PCI core.

