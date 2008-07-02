Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYGBImO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYGBImO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYGBIl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:41:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYGBIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:41:55 -0400
Subject: Re: [PATCH 14/23] make section names compatible with
	-ffunction-sections -fdata-sections: parisc
From: David Woodhouse <dwmw2@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
In-Reply-To: <200807020200.49518.vda.linux@googlemail.com>
References: <200807020239.11410.vda.linux@googlemail.com>
	 <1214955660.3316.31.camel@localhost.localdomain>
	 <200807020200.49518.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 09:41:47 +0100
Message-Id: <1214988107.10393.444.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 02:00 +0200, Denys Vlasenko wrote:
> On Wednesday 02 July 2008 01:41, James Bottomley wrote:
> > On Wed, 2008-07-02 at 02:39 +0200, Denys Vlasenko wrote:
> > > The purpose of this patch is to make kernel buildable
> > > with "gcc -ffunction-sections -fdata-sections".
> > > This patch fixes parisc architecture.
> > > 
> > > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> > 
> > Um ... if you look at the Makefile you'll see we already build parisc
> > with -ffunction-sections; we have to: our relative jumps are too small
> > to guarantee finding the stubs in large files.
> > 
> > Since our text is -ffunction-sections compatible already, I question the
> > need for transformations like this:

We've been building FR-V kernels with --gc-sections for a long time,
too.

> In order to handle these situations uniformly, in these patches
> I decided to _never_ use .text.XXXX names for sections,
> effectively leaving them "reserved for gcc's use".

It makes a certain amount of sense to do this uniformly for all
architectures -- leaving .text.* and .data.* for GCC, and using
something else whenever we manually name sections. 

Denys' patch for parisc would need a little more thought, but it's
probably worth it to be consistent. Especially if we can move more stuff
out of athe arch-specific linker scripts and into
<asm-generic/vmlinux.lds.h>

-- 
dwmw2

