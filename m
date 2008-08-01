Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbYHAV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbYHAV2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760984AbYHAVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:23:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598AbYHAVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nCByYO2izedImHE6GklK0aF43yiNF2gGp8RMwZZH5wytKCf4rdYmwYZgGm8Z00kAfX
         HZU5qxThw2tWL9KHqrSuX86fpf36qcc8Mypa0Ja/iC9hxnbwHm9Um0G6syuGsOJBjjn5
         gjrEQJQOQtgI6hWx0INZL8itkWqE2hfFf1Y6k=
Subject: Re: [PATCH 14/20] parisc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080801160647.GA22049@colo.lackof.org>
References: <1216339783.6029.125.camel@brick>
	 <20080801160647.GA22049@colo.lackof.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 14:23:37 -0700
Message-Id: <1217625817.5846.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 10:06 -0600, Grant Grundler wrote:
> On Thu, Jul 17, 2008 at 05:09:43PM -0700, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  include/asm-parisc/byteorder.h |   37 ++++++++++++-------------------------
> >  1 files changed, 12 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/asm-parisc/byteorder.h b/include/asm-parisc/byteorder.h
> > index db14831..5e56b1b 100644
> > --- a/include/asm-parisc/byteorder.h
> > +++ b/include/asm-parisc/byteorder.h
> > @@ -4,9 +4,10 @@
> >  #include <asm/types.h>
> >  #include <linux/compiler.h>
> >  
> > -#ifdef __GNUC__
> > +#define __LITTLE_ENDIAN
> 
> Sorry, this looks wrong. parisc is big endian.

Sorry, it is wrong.  It of course should be __BIG_ENDIAN

> > +#define __SWAB_64_THRU_32__
> 
> Should this only be defined if BITS_PER_LONG is <=32  ?
> 

The new byteorder headers only uses this if no __arch_swab64 is defined.

Further down in the parisc version, an __arch_swab64 is defined in the
BITS_PER_LONG >=32 case, making this moot.

>From the new linux/swab.h:

static inline __attribute_const__ __u64 ___swab64(__u64 val)
{
#ifdef __arch_swab64
	return __arch_swab64(val);
#elif defined(__arch_swab64p)
	return __arch_swab64p(&val);
#elif defined(__SWAB_64_THRU_32__)
	__u32 h = val >> 32;
	__u32 l = val & ((1ULL << 32) - 1);
	return (((__u64)___swab32(l)) << 32) | ((__u64)(___swab32(h)));
#else
	return __const_swab64(val);
#endif
}

Other than the endianness, any other concerns?

Harvey

