Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZGLEkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZGLEkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 00:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZGLEkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 00:40:47 -0400
Received: from ozlabs.org ([203.10.76.45]:33501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZGLEkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 00:40:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Date: Sun, 12 Jul 2009 14:10:39 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907111821.47769.rusty@rustcorp.com.au> <20090711084958.69ff9196@infradead.org>
In-Reply-To: <20090711084958.69ff9196@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907121410.39874.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 01:19:58 am Arjan van de Ven wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I have a question about this patch though: I think it's unsafe in
> > general to mark the last partial page as NX (we asked for executable
> > pages, this could remove executable from some unrelated allocation).
>
> we vmalloc / g_f_p modules right? so we don't share the last page.

Historically yes, but I don't think we should be counting on it.  It makes 
sense to kmalloc for small modules, and it's arch specific code.

OTOH, a quick grep shows currently only cris does kmalloc, and that's a config 
option.

It might be time to unify this code.  If we rename MODULE_START to 
MODULE_VADDR on MIPS, then ignoring CRIS there's only two real variants; 
vmalloc and __vmalloc.

(I like the idea of trying kmalloc and falling back, simply because it reduces 
TLB pressure, but that's probably best done after unification).

Thoughts?
Rusty.
