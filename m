Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXFPLef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXFPLef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXFPLe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:34:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35455 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXFPLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:34:20 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Woodhouse <dwmw2@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200706161321.35940.arnd@arndb.de>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <1181986686.25228.639.camel@pmac.infradead.org>
	 <200706161226.40875.arnd@arndb.de>  <200706161321.35940.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 12:34:11 +0100
Message-Id: <1181993652.25228.690.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 13:21 +0200, Arnd Bergmann wrote:
> On Saturday 16 June 2007, Arnd Bergmann wrote:
> > On Saturday 16 June 2007, David Woodhouse wrote:
> > > Will GCC know that it needs to emit code to handle that (mis)alignment?
> > 
> > I've tested this with gcc-4.0.3, and it does the right thing, which
> > is to split a 4 byte aligned 64 bit load/store into two 32 bit accesses,
> > if you pass -mstrict-align.
> 
> I just realized this was correct but slightly misleading. On powerpc, we
> don't set the 'attribute((aligned(4)))' on compat_64, so there is never
> a reason to handle the misalignment, even though it would work.

You're right. My question was probably not relevant -- all these 64-bit
architectures cope with misaligned loads anyway. If we ever have to deal
with 32-bit compat on a 64-bit architecture which can't handle
misalignment, I'm just going to hide under my desk and never come out.

> On x86_64, misaligned loads are always ok, so gcc never needs to
> care about this, even attribute((packed)) does not cause byte access
> here.

IA64 too, but it'll be handled there too -- either naturally or by
fixups; it doesn't matter.

-- 
dwmw2

