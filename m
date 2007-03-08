Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXCHQIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXCHQIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXCHQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:08:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41660 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXCHQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:08:53 -0500
Date: Thu, 8 Mar 2007 16:08:52 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308160852.GB9916@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	David Brown <dmlb2000@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gdb@sourceware.org
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173369229.3550.2.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 07:53:49AM -0800, Arjan van de Ven wrote:
> > > > PAGE_SIZE should not be available at all.  Please use getpagesize()
> > > > instead.
> > > 
> > > While I agree, NBPG is a bit of a problem, although it's only needed for aout 
> > > coredumps AFAICT, but still needed to compile e.g. gdb.
> > 
> > So we should export this one with an arbitrary value (on multiple page
> > size architectures) and a warning, maybe even an __deprecated attached to
> > it.
> 
> if we think the kernel should export this one, we could do
> 
> #ifndef __KERNEL__
> #define PAGE_SIZE getpagesize()
> #endif

No, no no.  We should never export PAGE_SIZE.  We might export NBPG
as deprecated symbol for gdb if it really needs it, but that should
happen only on a.out systems, and it it should be a true constant,
not depending on PAGE_SIZE.

I've Cc'ed the gdb list on whether they have any comments on this
issue.
