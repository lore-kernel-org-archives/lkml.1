Return-Path: <linux-kernel-owner+w=401wt.eu-S1423327AbXBHUtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423327AbXBHUtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423333AbXBHUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:49:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38556 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423318AbXBHUtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:49:50 -0500
Date: Thu, 8 Feb 2007 12:46:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
Message-Id: <20070208124629.c9c2c09d.akpm@linux-foundation.org>
In-Reply-To: <20070208203453.GA10122@infradead.org>
References: <1170920422.15989.354.camel@ymzhang>
	<20070208194204.GC2354@infradead.org>
	<20070208122539.d9c24ad9.akpm@linux-foundation.org>
	<20070208203453.GA10122@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 20:34:53 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 08, 2007 at 12:25:39PM -0800, Andrew Morton wrote:
> > On Thu, 8 Feb 2007 19:42:04 +0000
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Thu, Feb 08, 2007 at 03:40:22PM +0800, Zhang, Yanmin wrote:
> > > > If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> > > > fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> > > > to irq vector.
> > > > 
> > > > Below patch against kernel 2.6.20 fixes it.
> > > 
> > > These direct arch ifdefs in core aren't acceptable.
> > 
> > For 2.6.21 that's true.  But this is a suitable fix for 2.6.20.x, no?
> 
> Just putting in an #ifndef and allow to to set it up in asm/ata.h
> is almost as trivial and a lot nice conceptually.

Well if that's what the 2.6.21 solution looks like then OK.  Would want to
see the patch though.

>  Then again
> what happened to the idea of putting fixes into mainline before
> -stable?

If the preferred mainline patch involves a lot of not-really-needed
restructuring then an alternative short-but-obvious fix for -stable is
sometimes more appropriate.
