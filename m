Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXJOXYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXJOXYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXJOXX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:23:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXJOXX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:23:58 -0400
Date: Mon, 15 Oct 2007 16:23:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] Misc: phantom, synchronize_irq() on suspend
Message-Id: <20071015162344.dca7023c.akpm@linux-foundation.org>
In-Reply-To: <3012721321185026886@pripojeni.net>
References: <3012721321185026886@pripojeni.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 09:32:28 -0700
Jiri Slaby <jirislaby@gmail.com> wrote:

> phantom, synchronize_irq() on suspend
> 
> Wait after disabling device's interrupt until the handler finishes its
> work if still in progress.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit 7e792ef384190b517f2fb27cd0237fa30dbe0775
> tree 17b15e5ab7c90eef0e7ae57e532839e81b831d58
> parent 5c008a5651ee92ebe020dd5108a66a7db74fe41d
> author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200
> 
>  drivers/misc/phantom.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
> index 5108b7c..6e61a79 100644
> --- a/drivers/misc/phantom.c
> +++ b/drivers/misc/phantom.c
> @@ -378,6 +378,8 @@ static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
>  	iowrite32(0, dev->caddr + PHN_IRQCTL);
>  	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
>  
> +	synchronize_irq(pdev->irq);
> +
>  	return 0;
>  }
>  

What inspired this change?  Some bug report, or does it just seem the right
thing to do?

Would it be logical to do this operation from the PCI core somewhere, on
behalf of all PCI drivers?

