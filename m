Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZGLPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZGLPbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 11:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZGLPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 11:31:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZGLPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 11:31:08 -0400
Date: Sun, 12 Jul 2009 08:32:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090712083227.39939849@infradead.org>
In-Reply-To: <200907121928.28887.rusty@rustcorp.com.au>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907121410.39874.rusty@rustcorp.com.au>
	<20090712004524.2f0c4e57@infradead.org>
	<200907121928.28887.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 19:28:27 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sun, 12 Jul 2009 05:15:24 pm Arjan van de Ven wrote:
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > (I like the idea of trying kmalloc and falling back, simply
> > > because it reduces TLB pressure, but that's probably best done
> > > after unification).
> >
> > or using a non-power-of-two get_free_pages() thing...
> >
> > some architectures will need to know that memory needs to be
> > executable at allocation time so that it can be put in an
> > executable address range etc...
> 
> Yes, maybe that's better than kmalloc.  On my laptop I have 105
> modules loaded, with 3778464 total length: I'm wasting 206944 bytes
> on unused tails of pages.  But that's only 0.06% of my memory.
>

105 is also a sign that you picked a somewhat suboptimal config...
that's of course your choice but it's a choice that has a small price,
if you don't want to pay that price, changing the config to not be
entirely insane is a good answer as well ;-)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
