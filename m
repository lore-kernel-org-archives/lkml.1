Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXERU4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXERU4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXERU4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:56:46 -0400
Received: from cmsout02.mbox.net ([165.212.64.32]:61092 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXERU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:56:45 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 16:56:45 EDT
X-USANET-Source: 165.212.11.138  IN   avcp-lkmail@usa.net cmsapps02.cms.usa.net
X-USANET-MsgId: XID855LeRuvR8165X02
X-USANET-Auth: 205.247.13.101  AUTH codepro@usa.net MUMBA
From: "Alex Volkov" <avcp-lkmail@usa.net>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: aio is unlikely
Date: Fri, 18 May 2007 16:49:49 -0400
Message-ID: <058f01c7998e$1406e370$650df7cd@MUMBA>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070509151831.f5956b66.akpm@linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceSiCxQRdhLuphwRQKb3UJVSUO6yQHBHi1Q
Z-USANET-MsgId: XID813LeRuvP0129X38
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton wrote:
>     aio is unlikely
>     Stick an unlikely() around is_aio(): I assert that most IO is
synchronous.
>
> -#define in_aio() !is_sync_wait(current->io_wait)
> +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))

> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > > -#define in_aio() !is_sync_wait(current->io_wait)
> > > +#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
> > 
> > Please revert.  Workload-dependent "likelihood" should not cause 
> > programmers to add such markers.
> a) disagree with the above
> 
> b) if in_aio() ever returns true we do
> 
> 	printk(KERN_ERR "%s(%s:%d) called in async context!\n",
> 		__FUNCTION__, __FILE__, __LINE__);
> 
>    so I sure hope it's unlikely for all workloads. 

Shouldn't unlikely() go where in_aio() is actually used, if we printk(error)
there?
Isn't putting likely/unlikely into a boolean function-like macro itself
asking for later trouble?

--Alex.


