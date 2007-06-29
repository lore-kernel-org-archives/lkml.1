Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXF2Pgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXF2Pgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbXF2Pgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:36:45 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43346 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbXF2Pgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:36:44 -0400
X-Originating-Ip: 74.102.207.204
Date: Fri, 29 Jun 2007 11:34:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
In-Reply-To: <20070629145821.GA7003@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0706291132450.16107@localhost.localdomain>
References: <20070628140921.GA9753@localhost.sw.ru>
 <20070628151257.7a03e81b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
 <20070629145821.GA7003@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Alexey Dobriyan wrote:

> On Fri, Jun 29, 2007 at 09:10:52AM -0400, Robert P. J. Day wrote:

> >   i actually asked about this on either the janitors or newbies
> > list the other day -- one of the early examples from the LDD3
> > device drivers book which built fine all this time suddenly
> > stopped building, until i explicitly included <linux/sched.h> to
> > be able to dereference a pointer to "task_struct":
> >
> > /home/rpjday/AMD/k/topics/0_hi/hi1.c:15: error: dereferencing pointer to incomplete type
> > /home/rpjday/AMD/k/topics/0_hi/hi1.c:16: error: dereferencing pointer to incomplete type
> >
> >   clearly, until now, that header file was being picked up
> > *somewhere*,
>
> from include/linux/mm.h , yes
>
> > but not now.
>
> dammit!
>
> > so i'm guessing there's going to be code all over the place that
> > suddenly needs to add that inclusion of sched.h.
>
> this is the last known to me bit of compile breakage that was caused by
> commit e8edc6e03a5c8562dc70a6d969f732bdb355a7e7 aka
> "[PATCH] Detach sched.h from mm.h"
>
> And after you'll check diffstat and build current kernel for
> different archs yourself, I hope you'll take that "all over the
> place" back.

i didn't mean code *in the kernel* necessarily, merely code
representing out-of-tree loadable drivers that will now need to
include sched.h that didn't need it before.  such as that very example
out of LDD3.

sorry that i wasn't more clear about that.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
