Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbXBKG7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbXBKG7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXBKG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:59:31 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22094 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXBKG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:59:30 -0500
Date: Sat, 10 Feb 2007 22:55:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-Id: <20070210225511.384f894b.randy.dunlap@oracle.com>
In-Reply-To: <20070211063431.GS10050@ftp.linux.org.uk>
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com>
	<20070211034902.GA9077@infradead.org>
	<45CEB720.1020406@gmail.com>
	<20070211063431.GS10050@ftp.linux.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 06:34:31 +0000 Al Viro wrote:

> My current version:
> 
> >From 97f115834b5ebef4f04e0f18aaa10f78f43733a0 Mon Sep 17 00:00:00 2001
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Sat, 10 Feb 2007 23:41:09 -0500
> Subject: [PATCH] sort the devres mess out
> 
> Split the implementation-agnostic stuff in separate files.
> Make sure that targets using non-default request_irq() pull kernel/irq/devres.o
> Mark targets that have no ioport_map() and friends, protect the ioport-related
> Parts of lib/devres.o with corresponding ifdef (BTW, we need it in driver
> dependencies in quite a few of cases, so that symbol was needed anyway).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1523046..7215152 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -29,6 +29,10 @@ config MMU
>  	bool
>  	default y
>  
> +config NO_IOPORT
> +	bool
> +	default n

Uh, I think that we would rather see a positive-sense symbol instead
of a negative one.  Any reason that this one prefers to be negative?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
