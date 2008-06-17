Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYFQJrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYFQJrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYFQJrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:47:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYFQJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:47:37 -0400
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20080617084235.GA20169@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi>
	 <1213619214.26255.721.camel@pmac.infradead.org>
	 <20080617084235.GA20169@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 10:46:44 +0100
Message-Id: <1213696004.26255.960.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 11:42 +0300, Adrian Bunk wrote:
> 
> > Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
> > <asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
> > sense?
> 
> My guess would be that binfmt_aout isn't actually used there.
> 
> The affected architectures are:
> - h8300
> - m32r
> - parisc
> - sh
> - v850
> 
> v850 is broken beyond repair, and I hope my patch to remove the 
> architecture will make it into 2.6.27.
> 
> For the other 4 architectures I have Cc'ed the architecture maintainers.

There's another set of architectures which have <asm/a.out.h> but don't
define ARCH_SUPPORTS_AOUT. Including PowerPC.

I think we can probably get away with removing <asm/a.out.h> from every
architecture other than Alpha, ARM, m68k and x86, and killing
ARCH_SUPPORTS_AOUT completely.

Or maybe, as dhowells suggests, re-defining ARCH_SUPPORTS_AOUT to be set
only on Alpha, ARM, m68k and x86 (so BINFMT_AOUT can depend on it).

-- 
dwmw2

