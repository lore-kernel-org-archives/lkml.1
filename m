Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXBKDtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXBKDtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 22:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXBKDtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 22:49:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXBKDtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 22:49:19 -0500
Date: Sun, 11 Feb 2007 03:49:02 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070211034902.GA9077@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:45:50PM +0100, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> 9ac7849e35f705830f7b016ff272b0ff1f7ff759 causes this:
> 
>   CC      arch/s390/mm/ioremap.o
> In file included from arch/s390/mm/ioremap.c:18:
> include/linux/io.h:46:
> 	warning: "struct pci_dev" declared inside parameter list
> include/linux/io.h:46:
> 	warning: its scope is only this definition or declaration,
> 		 which is probably not what you want
> 
> Guess it's time to get rid of ioremap.c on s390 if possible...
> 
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/linux/io.h |    1 +
>  1 files changed, 1 insertion(+)
> 
> Index: linux-2.6/include/linux/io.h
> ===================================================================
> --- linux-2.6.orig/include/linux/io.h
> +++ linux-2.6/include/linux/io.h
> @@ -22,6 +22,7 @@
>  #include <asm/io.h>
>  #include <asm/page.h>
>  
> +struct pci_dev;
>  struct device;

I haven't looked at what causes it, but any leakage of pci details
into io.h is bogus.  I'd suggest that the original submitter fixes
up that problem instead.

