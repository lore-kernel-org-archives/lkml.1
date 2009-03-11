Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZCKIeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZCKIeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZCKIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:33:50 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51800 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbZCKIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:33:48 -0400
Date: Wed, 11 Mar 2009 09:33:45 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jason Baron <jbaron@redhat.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Greg Banks <gnb@sgi.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: driver-core tree build failure
In-Reply-To: <20090310200200.GB3091@redhat.com>
Message-ID: <alpine.LRH.2.00.0903110930120.314@vixen.sonytel.be>
References: <20090310192440.949884a1.sfr@canb.auug.org.au> <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be> <20090310145311.6bf9d9e9@skybase> <alpine.LRH.2.00.0903101626450.25436@vixen.sonytel.be> <20090310170841.2257de86@skybase>
 <20090310200200.GB3091@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Jason Baron wrote:
> On Tue, Mar 10, 2009 at 05:08:41PM +0100, Martin Schwidefsky wrote:
> > On Tue, 10 Mar 2009 16:29:50 +0100 (CET)
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > > The same could be done with the problematic pr_fmt definition:
> > > > 
> > > > #define pr_fmt(fmt)     __func__ ": " fmt
> > > 
> > > No, that also doesn't work:
> > > 
> > > | crypto/zlib.c:150: error: expected '}' before string constant
> > > | crypto/zlib.c:150: error: expected ')' before '__func__'
> > > | crypto/zlib.c:162: error: expected '}' before string constant
> > > | crypto/zlib.c:162: error: expected ')' before '__func__'
> > > | crypto/zlib.c:166: error: expected '}' before string constant
> > > | crypto/zlib.c:166: error: expected ')' before '__func__'
> > > | crypto/zlib.c:170: error: expected '}' before string constant
> > > | crypto/zlib.c:170: error: expected ')' before '__func__'
> > > 
> > > > > BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
> > > > > intended usage of your pr_fmt() infrastructure?
> > > > 
> > > > The indended use is a simple prefix to the format string. To paste an
> > > > additional parameter is an interesting use of the pr_fmt macro ..
> > > 
> > > Bummer, I was so happy I could do things like
> > > 
> > > | #define pr_fmt(fmt)	"%s:%u: " fmt, __func__, __LINE__
> > 
> > Actually that seem like a nice thing to have. With the upstream version of
> > dynamic_pr_debug this works, there the format string is used only on a printk.
> > git commit 25b67b75587d43ff3f09ad88c03c70a38372d95d introduces the code
> > that pastes the format string to the _ddebug structure.
> > 
> 
> hmmm...yeah, some macro magic in include/linux/dynamic_debug.h converts
> the 'fmt' arg into a series of strings. It doesn't look as pretty in the
> dynamic debug control file:
> 
> crypto/zlib.c:333 [zlib]zlib_decompress_final - "\042%s: \042
> \042avail_in %u, avail_out %u (consumed %u, produced %u)\n\042,
> __func__"
> 
> with all those '\042' there, which are the '"' characters, but we
> probably could live with it.

Ugh, not only that, it also contains the __func__.

BTW, why do you store this string? The only thing you can do with it later is
to print it verbatim (without % format parameter expansion), as it has
swallowed the first parameter (__func__), but still contains the %s.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
