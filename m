Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZGMLCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZGMLCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZGMLCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:02:11 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:56720 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbZGMLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:02:10 -0400
Date: Mon, 13 Jul 2009 12:59:49 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090713105948.GI12383@axis.com>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907111821.47769.rusty@rustcorp.com.au> <20090711084958.69ff9196@infradead.org> <200907121410.39874.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907121410.39874.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 06:40:39AM +0200, Rusty Russell wrote:
> On Sun, 12 Jul 2009 01:19:58 am Arjan van de Ven wrote:
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > I have a question about this patch though: I think it's unsafe in
> > > general to mark the last partial page as NX (we asked for executable
> > > pages, this could remove executable from some unrelated allocation).
> >
> > we vmalloc / g_f_p modules right? so we don't share the last page.
> 
> Historically yes, but I don't think we should be counting on it.  It makes 
> sense to kmalloc for small modules, and it's arch specific code.
> 
> OTOH, a quick grep shows currently only cris does kmalloc, and that's a config
> option.

...which is a not often used debug option.

> It might be time to unify this code.  If we rename MODULE_START to 
> MODULE_VADDR on MIPS, then ignoring CRIS there's only two real variants; 
> vmalloc and __vmalloc.
> 
> (I like the idea of trying kmalloc and falling back, simply because it reduces 
> TLB pressure, but that's probably best done after unification).
> 
> Thoughts?
> Rusty.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
