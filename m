Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZE2D6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZE2D6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZE2D6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:58:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43764 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:58:38 -0400
Date: Fri, 29 May 2009 12:58:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Williams <jwilliams@itee.uq.edu.au>
Cc: Johannes Weiner <jw@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
       michal.simek@petalogix.com
Subject: Re: [patch -v2] flat: fix data sections alignment
Message-ID: <20090529035820.GC1122@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	John Williams <jwilliams@itee.uq.edu.au>,
	Johannes Weiner <jw@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
	michal.simek@petalogix.com
References: <E1LerUo-0000NE-Q3@mailer.emlix.com> <9e6f3dfd0905281701y6141e5d2xbbfb37e495cba8d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e6f3dfd0905281701y6141e5d2xbbfb37e495cba8d9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 10:01:51AM +1000, John Williams wrote:
> Hi,
> 
> On Wed, Mar 4, 2009 at 11:51 PM, Johannes Weiner <jw@emlix.com> wrote:
> > From: Oskar Schirmer <os@emlix.com>
> >
> > The flat loader uses an architecture's flat_stack_align() to align the
> > stack but assumes word-alignment is enough for the data sections.
> >
> > However, on the Xtensa S6000 we have registers up to 128bit width
> > which can be used from userspace and therefor need userspace stack and
> > data-section alignment of at least this size.
> >
> > This patch drops flat_stack_align() and uses the same alignment that
> > is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
> > not defined by the architecture.
> >
> > It also fixes m32r which was obviously kaput, aligning an
> > uninitialized stack entry instead of the stack pointer.
> >
> 
> > ---
> > ?arch/arm/include/asm/flat.h ? ? ?| ? ?3 ---
> > ?arch/blackfin/include/asm/flat.h | ? ?1 -
> > ?arch/h8300/include/asm/flat.h ? ?| ? ?1 -
> > ?arch/m68k/include/asm/flat.h ? ? | ? ?1 -
> > ?arch/sh/include/asm/flat.h ? ? ? | ? ?1 -
> > ?fs/binfmt_flat.c ? ? ? ? ? ? ? ? | ? 37 ++++++++++++++++++++++---------------
> > ?include/asm-m32r/flat.h ? ? ? ? ?| ? ?1 -
> > ?7 files changed, 22 insertions(+), 23 deletions(-)
> 
> Can you please cross-check this patch for MicroBlaze as well, we are
> another active nommu architecture.
> 
I already did, see http://lkml.org/lkml/2009/5/27/753

You just need to kill off your flat_stack_align(), as it doesn't do
anything presently it is harmless one way or the other.
