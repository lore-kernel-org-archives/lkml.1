Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYFPPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYFPPr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYFPPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:47:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYFPPrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:47:20 -0400
Subject: Re: [PATCH v2] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
In-Reply-To: <9834.1213624094@redhat.com>
References: <1213619214.26255.721.camel@pmac.infradead.org>
	 <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi> <9834.1213624094@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 16:47:06 +0100
Message-Id: <1213631226.26255.799.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 14:48 +0100, David Howells wrote:
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
> > <asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
> > sense?
> 
> Maybe because some arches supported ELF with AOUT interpreters but not full
> AOUT binaries?

Is that sane? I thought a.out interpreters for ELF were a transitional
thing to cope with moving from a.out to ELF. Would anyone really do that
unless they had real a.out support in the first place?

I'm more inclined to believe that they just blindly copied <asm/user.h>
from i386 when the arch was created, and then later got
ARCH_SUPPORTS_AOUT defined for that arch because they had a
<asm/a.out.h>.

I suspect we could actually just remove <asm/a.out.h> for all
architectures except Alpha, x86, ARM and m68k. We'd probably have to
remove inclusions of <linux/a.out.h> from a few places in arch code, but
all of them will turn out to be gratuitous anyway.

-- 
dwmw2

