Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbZEKWvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbZEKWvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZEKWv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:51:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758114AbZEKWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:51:29 -0400
Date: Mon, 11 May 2009 15:48:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] cred: #include init.h in cred.h
Message-Id: <20090511154857.eacb2788.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.00.0905120831560.3090@tundra.namei.org>
References: <20090509033652.GB3224@x200.localdomain>
	<20090511132006.fedc9352.akpm@linux-foundation.org>
	<alpine.LRH.2.00.0905120831560.3090@tundra.namei.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 08:32:31 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> On Mon, 11 May 2009, Andrew Morton wrote:
> 
> > On Sat, 9 May 2009 07:36:52 +0400
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > linux/cred.h can't be included as first header (alphabetical order)
> > > because it uses __init which is enough to break compilation on some
> > > archs.
> > > 
> > 
> > hm, OK, not a lot of detail there though.
> > 
> > > 
> > > --- a/include/linux/cred.h
> > > +++ b/include/linux/cred.h
> > > @@ -13,6 +13,7 @@
> > >  #define _LINUX_CRED_H
> > >  
> > >  #include <linux/capability.h>
> > > +#include <linux/init.h>
> > >  #include <linux/key.h>
> > >  #include <asm/atomic.h>
> > 
> > I assume that this is needed in 2.6.30?
> > 
> 
> I can see it's in -mm, so might as well go to Linus via there.

No prob.

> Acked-by: James Morris <jmorris@namei.org>

Thanks.

This is not the sort of patch which I'd send upstream immediately. 
cred.h is included by sched.h and sched.h doesn't include init.h. 
That's enough uncertainty to require a few days compile-testing..


