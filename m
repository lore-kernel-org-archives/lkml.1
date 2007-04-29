Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXD2QYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXD2QYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbXD2QYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:24:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42172 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756519AbXD2QYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:24:49 -0400
Date: Sun, 29 Apr 2007 17:27:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Hans-J?rgen Koch <hjk@linutronix.de>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070429172749.53843a21@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.61.0704291403080.506@yvahk01.tjqt.qr>
References: <20070427224957.GA17967@kroah.com>
	<4633A6D7.3030806@tmr.com>
	<200704282203.31141.hjk@linutronix.de>
	<20070428211515.4e9fd8c5@the-village.bc.nu>
	<1177792297.7646.297.camel@localhost.localdomain>
	<20070429012338.GA11147@suse.de>
	<1177835453.5791.7.camel@localhost.localdomain>
	<Pine.LNX.4.61.0704291403080.506@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Right, this is just a hint, that something in user space is accessing
> >the hardware directly. Not a too bad idea, but pretty much useless when
> >we add X to the picture as it will be set always :)
> 
> Index: linux-2.6.21-mm_20040728/drivers/char/mem.c
> ===================================================================
> --- linux-2.6.21-mm_20040728.orig/drivers/char/mem.c
> +++ linux-2.6.21-mm_20040728/drivers/char/mem.c
> @@ -274,6 +274,9 @@ static int mmap_mem(struct file * file, 
>  	if (!private_mapping_ok(vma))
>  		return -ENOSYS;
>  
> +	if (strcmp(current->comm, "Xorg") != 0)
> +		tainted |= TAINT_USER;
> +

The X server has many names.  Xorg isn't the name of the server here for
example (its "X"). 

Alan
