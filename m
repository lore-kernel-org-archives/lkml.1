Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbXFFRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbXFFRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbXFFRYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:24:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbXFFRYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:24:10 -0400
Date: Wed, 6 Jun 2007 10:23:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606102328.52e1b3f8.akpm@linux-foundation.org>
In-Reply-To: <4666BB44.6040205@shadowen.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4666B141.8000102@fr.ibm.com>
	<4666BB44.6040205@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 14:48:52 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> Cedric Le Goater wrote:
> > Andrew,
> > 
> > here's a minor fix for x86_64,
> > 
> > C.
> > 
> > 
> > when CONFIG_PM=y and CONFIG_SOFTWARE_SUSPEND=n, 
> > 
> >   CC      arch/x86_64/kernel/e820.o
> > /home/legoater/linux/2.6.22-rc4-mm1/arch/x86_64/kernel/e820.c: In function `e820_mark_nosave_regions':
> > /home/legoater/linux/2.6.22-rc4-mm1/arch/x86_64/kernel/e820.c:248: warning: implicit declaration of function `register_nosave_region'
> > 
> > Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> > ---
> >  include/linux/suspend.h |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > Index: 2.6.22-rc4-mm1/include/linux/suspend.h
> > ===================================================================
> > --- 2.6.22-rc4-mm1.orig/include/linux/suspend.h
> > +++ 2.6.22-rc4-mm1/include/linux/suspend.h
> > @@ -74,6 +74,14 @@
> >  extern void hibernation_set_ops(struct hibernation_ops *ops);
> >  extern int hibernate(void);
> >  #else /* CONFIG_SOFTWARE_SUSPEND */
> > +static inline void register_nosave_region(unsigned long b, unsigned long e)
> > +{
> > +}
> > +
> > +static inline void register_nosave_region_late(unsigned long b, unsigned long e)
> > +{
> > +}
> > +
> >  static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
> >  static inline void swsusp_set_page_free(struct page *p) {}
> >  static inline void swsusp_unset_page_free(struct page *p) {}
> > -
> 
> 
> Looks like this is the cause of a bunch of compile failures across our
> testing.  Will shove this through tko.
> 

Yeah.  I put a different fix into the hot-fixes directory, thanks.

The powerpc failure is nasty - probably a toolchain stupidity.  I reverted
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch which
_should_ fix it, but really the problem is triggered by ilog2().

