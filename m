Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZEHWes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZEHWes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZEHWei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:34:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:36438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZEHWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:34:37 -0400
Subject: Re: [RFC PATCH 0/3] generic hypercall support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <200905080011.52958.arnd@arndb.de>
References: <4A031471.7000406@novell.com> <4A034F0E.6010603@gmail.com>
	 <20090507215712.GI3036@sequoia.sous-sol.org>
	 <200905080011.52958.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 09 May 2009 08:33:18 +1000
Message-Id: <1241821998.29028.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 00:11 +0200, Arnd Bergmann wrote:
> On Thursday 07 May 2009, Chris Wright wrote:
> > 
> > > Chris, is that issue with the non ioread/iowrite access of a mangled
> > > pointer still an issue here?  I would think so, but I am a bit fuzzy on
> > > whether there is still an issue of non-wrapped MMIO ever occuring.
> > 
> > Arnd was saying it's a bug for other reasons, so perhaps it would work
> > out fine.
> 
> Well, maybe. I only said that __raw_writel and pointer dereference is
> bad, but not writel.

I have only vague recollection of that stuff, but basically, it boiled
down to me attempting to use annotations to differenciate old style
"ioremap" vs. new style iomap and effectively forbid mixing ioremap with
iomap in either direction.

This was shot down by a vast majority of people, with the outcome being
an agreement that for IORESOURCE_MEM, pci_iomap and friends must return
something that is strictly interchangeable with what ioremap would have
returned.

That means that readl and writel must work on the output of pci_iomap()
and similar, but I don't see why __raw_writel would be excluded there, I
think it's in there too.

Direct dereference is illegal in all cases though.

The token returned by pci_iomap for other type of resources (IO for
example) is also only supported for use by iomap access functions
(ioreadXX/iowriteXX) , and IO ports cannot be passed directly to those
neither.

Cheers,
Ben.

