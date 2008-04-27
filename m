Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYD0Wg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYD0Wg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYD0Wgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:36:50 -0400
Received: from 1wt.eu ([62.212.114.60]:3470 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYD0Wgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:36:49 -0400
Date: Mon, 28 Apr 2008 00:36:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427223620.GJ8474@1wt.eu>
References: <1209329485.3801.46.camel@localhost.localdomain> <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209333959.3801.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 06:05:59PM -0400, James Bottomley wrote:
> > Index: linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
> > ===================================================================
> > --- linux-x86.q.orig/arch/x86/mach-voyager/voyager_cat.c
> > +++ linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
> > @@ -602,7 +602,7 @@ void __init voyager_cat_init(void)
> >  
> >  		request_resource(&iomem_resource, &res);
> >  		voyager_SUS = (struct voyager_SUS *)
> > -		    ioremap(addr, 0x400);
> > +		    ioremap_cache(addr, 0x400);
> 
> Actually, no ... wrong ioremap.  That one is the SUS clickmap remap,
> which is irrelevant whether it's cached or not. The QIC cacheline area
> is the next one below it.
> 
> I've already got the actual patch (with a nice explanation) in the
> voyager tree.  I'll send them all out to the mailing list shortly; I'm
> just trying to chase down a problem with TSCs before the voyager tree is
> ready.

James,

whatever the fix, please add a comment on the sensible line above so
that the same error does not happen again. Code must be readable without
comments, but magic choices must be commented if there's an underlying
reason.

Thanks,
Willy

