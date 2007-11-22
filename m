Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXKVAzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXKVAzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXKVAzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:55:43 -0500
Received: from mx27.mail.ru ([194.67.23.23]:20806 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXKVAzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:55:42 -0500
Date: Thu, 22 Nov 2007 03:49:59 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: ian <spyro@f2s.com>
Cc: eric miao <eric.y.miao@gmail.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
Message-ID: <20071122004959.GA1965@zarina>
Reply-To: cbou@mail.ru
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com> <1195597252.2329.70.camel@wirenth> <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com> <1195617255.2329.78.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1195617255.2329.78.camel@wirenth>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Personally I'm very appreciate your patches, they'll will
help submitting HP iPaqs SOCs/MFDs, you know... ;-)

Thus, much thanks in advance.

Few comments...

On Wed, Nov 21, 2007 at 03:54:15AM +0000, ian wrote:
> On Wed, 2007-11-21 at 10:23 +0800, eric miao wrote:
> > Roughly went through the patch, looks good, here comes the remind, though :-)
> > 
> > 1. is it possible to use some name other than "soc_core", maybe
> > "tmio_core" so that other multifunction chips sharing a core base
> > will live easier.
> 
> It's (soc-core) not tmio MFD specific - its already used by other MFD
> chips (although obviously not ones in mainline (yet!)
> 
> it might be better named 'mfd-core' though, as thats its intended use...
> 
> > 2. those C++ style comments "//" are not so pleasant...
> 
> Should I clean them up and resubmit?

I'd resubmit cleaned up version. I think four or even more
resubmissions is inevitable for such patch-set (new general code +
a lot of drivers).

About patches their self... I think soc_add_devices could be
split into two small functions, thus you'll get rid of high
indentation level + code will be more reader friendly.


Ideally, checkpatch.pl should be happy. If it will, then there will
be less nitpicks somebody can pull. ;-)

Here it is:
- - - -
~/linux-2.6$ scripts/checkpatch.pl ~/0001-Reuseable-SOC-core-code-suitable-for-multifunction-c.patch
WARNING: line over 80 characters
#57: FILE: drivers/mfd/soc-core.c:37:
+#define SIGNED_SHIFT(val, shift) ((shift) >= 0 ? ((val) << (shift)) : ((val) >> -(shift)))

WARNING: line over 80 characters
#60: FILE: drivers/mfd/soc-core.c:40:
+                                       struct soc_device_data *soc, int nr_devs,

WARNING: line over 80 characters
#84: FILE: drivers/mfd/soc-core.c:64:
+               res = kzalloc(blk->num_resources * sizeof (struct resource), GFP_KERNEL);

WARNING: no space between function name and open parenthesis '('
#84: FILE: drivers/mfd/soc-core.c:64:
+               res = kzalloc(blk->num_resources * sizeof (struct resource), GFP_KERNEL);

ERROR: do not use C99 // comments
#89: FILE: drivers/mfd/soc-core.c:69:
+                       res[r].name = blk->res[r].name; // Fixme - should copy

WARNING: braces {} are not necessary for single statement blocks
#93: FILE: drivers/mfd/soc-core.c:73:
+                       if (blk->res[r].flags & IORESOURCE_MEM) {
+                               base = mem->start;
+                       } else if ((blk->res[r].flags & IORESOURCE_IRQ) &&

WARNING: braces {} are not necessary for single statement blocks
#95: FILE: drivers/mfd/soc-core.c:75:
+                       } else if ((blk->res[r].flags & IORESOURCE_IRQ) &&
+                               (blk->res[r].flags & IORESOURCE_IRQ_SOC_SUBDEVICE)) {
+                               base = irq_base;
+                       }

WARNING: line over 80 characters
#96: FILE: drivers/mfd/soc-core.c:76:
+                               (blk->res[r].flags & IORESOURCE_IRQ_SOC_SUBDEVICE)) {

WARNING: line over 80 characters
#103: FILE: drivers/mfd/soc-core.c:83:
+                               res[r].start = base + SIGNED_SHIFT(blk->res[r].start, relative_addr_shift);

WARNING: line over 80 characters
#104: FILE: drivers/mfd/soc-core.c:84:
+                               res[r].end   = base + SIGNED_SHIFT(blk->res[r].end,   relative_addr_shift);

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 9 warnings, 145 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
- - - -

There is false positive though:

if (...) {
	single_stmt;
} else {
	one;
	two;
}

^^^ is perfectly OK and preferred, IIRC. checkpatch isn't ideal,
but it's mostly good.

> More to the point, who should I be submitting them to? the files under
> arm/ are obviously for RMK to peruse, but I couldnt find an entry for
> drivers/mfd in MAINTAINERS...

Well, don't know about drivers/mfd/*. Probably there simply isn't
any [official] maintainer, thus lkml is the right place.

There is one not so obvious thing though: you should not submit patches
with To/Cc'ing lkml (open list) and linux-arm-kernel (subscribers-only).

Russell King will probably point to linux-arm-kernel etiquette article
(http://www.arm.linux.org.uk/mailinglists/etiquette.php
"Cross-posting between linux-arm* lists and other lists.")

So, either place linux-arm-kernel into Bcc:, or duplicate stuff for
lkml and linux-arm-kernel separately, thus they'll not see each
others' To/Cc.


Looking forward to your patches!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
