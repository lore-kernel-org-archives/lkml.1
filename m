Return-Path: <linux-kernel-owner+w=401wt.eu-S934942AbXKPVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934942AbXKPVu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbXKPVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:50:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbXKPVuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:50:51 -0500
Subject: Re: [PATCH 2/3] mmap: round mmap hint address above mmap_min_addr
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
In-Reply-To: <Xine.LNX.4.64.0711170841200.22208@us.intercode.com.au>
References: <1195246486.2924.87.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0711170841200.22208@us.intercode.com.au>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 16:49:53 -0500
Message-Id: <1195249793.2924.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-17 at 08:42 +1100, James Morris wrote:
> On Fri, 16 Nov 2007, Eric Paris wrote:
> 
> > +#ifdef CONFIG_SECURITY
> > +	/*
> > +	 * If a hint addr is less than mmap_min_addr change addr to be as
> > +	 * low as possible but still greater than mmap_min_addr
> > +	 */
> > +	if (!(flags & MAP_FIXED) && ((void *)addr != NULL) &&
> > +	    (addr < mmap_min_addr))
> > +		addr = PAGE_ALIGN(mmap_min_addr);
> > +#endif
> 
> Please make this a static inline which is optimized away with 
> !CONFIG_SECURITY.

Where do you think these should go?  You think I should instead have a
static inline function in both mmap.c and nommu.c so the CONFIG check
isn't scattered in this code but still in this file?  Or did you
actually want something in security.h so I only have the code once?

-Eric

