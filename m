Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXLFHLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXLFHLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXLFHLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:11:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbXLFHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:11:35 -0500
Date: Wed, 5 Dec 2007 23:10:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Joe Perches <joe@perches.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       jengelh@computergmbh.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
Message-Id: <20071205231040.f6c9b40e.akpm@linux-foundation.org>
In-Reply-To: <831AEA99-3615-4015-9415-A4572D690095@mac.com>
References: <1196359724.22120.22.camel@localhost>
	<20071129102400.dac158d8.randy.dunlap@oracle.com>
	<1196361860.22120.27.camel@localhost>
	<474F0A68.1080809@oracle.com>
	<1196369873.22120.69.camel@localhost>
	<474F28EB.20608@oracle.com>
	<Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>
	<1196378922.22120.72.camel@localhost>
	<20071205160133.0766c4f5.akpm@linux-foundation.org>
	<1196907017.10819.49.camel@localhost>
	<47575C07.1080001@oracle.com>
	<1196908955.10819.64.camel@localhost>
	<831AEA99-3615-4015-9415-A4572D690095@mac.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 00:58:38 -0500 Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Dec 05, 2007, at 21:42:35, Joe Perches wrote:
> > On Wed, 2007-12-05 at 18:18 -0800, Randy Dunlap wrote:
> >> Joe Perches wrote:
> >>> Maybe just eliminate the 16 or 32 byte width option and force it  
> >>> to only 16 byte widths.
> >> Have you checked users (callers)?  I'm pretty sure that one of the  
> >> callers wanted 32 and that's why it's there.
> >
> > I did.  There is only 1 subsystem.  That's easy to change.
> >
> > drivers/mtd/ubi/debug.c:  print_hex_dump(KERN_DEBUG, "",  
> > DUMP_PREFIX_OFFSET, 32, 1,
> > drivers/mtd/ubi/io.c:     print_hex_dump(KERN_DEBUG, "",  
> > DUMP_PREFIX_OFFSET, 32, 1,
> >
> > Long lines in the log file are not too easy to read anyway.  Using  
> > 16 byte dumps per line instead of 32 isn't painful.
> >
> > It gets rid of the allocation, reduces the argument count and makes  
> > the kernel smaller.  I think it's all good.
> >
> > Every current caller would have to change though.
> 
> Alternatively, since print_hex_dump is not a performance-critical  
> path (and usually indicates an error/debug condition), you could  
> probably just make a static "hexdump_lock" spinlock and  
> spin_lock_irqsave()/spin_unlock_irqrestore().  It would always nest  
> inside any other lock (except during crash, where we break locks  
> already for printk()), and I doubt any of the callers would notice  
> the serialization since they're already serialized on the printk buffer.
> 

Yup, that'd work.
