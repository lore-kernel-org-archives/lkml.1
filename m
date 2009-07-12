Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZGLHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZGLHoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZGLHoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:44:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:59708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZGLHoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:44:06 -0400
Date: Sun, 12 Jul 2009 00:45:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090712004524.2f0c4e57@infradead.org>
In-Reply-To: <200907121410.39874.rusty@rustcorp.com.au>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907111821.47769.rusty@rustcorp.com.au>
	<20090711084958.69ff9196@infradead.org>
	<200907121410.39874.rusty@rustcorp.com.au>
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

On Sun, 12 Jul 2009 14:10:39 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sun, 12 Jul 2009 01:19:58 am Arjan van de Ven wrote:
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > I have a question about this patch though: I think it's unsafe in
> > > general to mark the last partial page as NX (we asked for
> > > executable pages, this could remove executable from some
> > > unrelated allocation).
> >
> > we vmalloc / g_f_p modules right? so we don't share the last page.
> 
> Historically yes, but I don't think we should be counting on it.  It
> makes sense to kmalloc for small modules, and it's arch specific code.
> 
> OTOH, a quick grep shows currently only cris does kmalloc, and that's
> a config option.
> 
> It might be time to unify this code.  If we rename MODULE_START to 
> MODULE_VADDR on MIPS, then ignoring CRIS there's only two real
> variants; vmalloc and __vmalloc.
> 
> (I like the idea of trying kmalloc and falling back, simply because
> it reduces TLB pressure, but that's probably best done after
> unification).
> 

or using a non-power-of-two get_free_pages() thing...

some architectures will need to know that memory needs to be executable
at allocation time so that it can be put in an executable address range
etc...
