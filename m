Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYCHM3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYCHM3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 07:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYCHM3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 07:29:08 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45204 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085AbYCHM3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 07:29:07 -0500
Date: Sat, 8 Mar 2008 20:28:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Milan Broz <mbroz@redhat.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Message-ID: <20080308122850.GA27182@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au> <47BC67CE.9070407@redhat.com> <20080220175819.GA28246@gondor.apana.org.au> <20080222123423.GA12678@gondor.apana.org.au> <e9c3a7c20803071014s6388b7b2l12f217bfdff5caa3@mail.gmail.com> <20080308012438.GA24236@gondor.apana.org.au> <1204947764.27096.4.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204947764.27096.4.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 08:42:44PM -0700, Dan Williams wrote:
> On Fri, 2008-03-07 at 18:24 -0700, Herbert Xu wrote:
> > On Fri, Mar 07, 2008 at 11:14:07AM -0700, Dan Williams wrote:
> > >
> > > I believe this is in mainline as 76fc60a2 "[CRYPTO] skcipher: Move
> > > chainiv/seqiv into crypto_blkcipher module".  With a iop13xx_defconfig
> > >  I get:
> > >
> > > `chainiv_module_exit' referenced in section `.init.text' of
> > > crypto/built-in.o: defined in discarded section `.exit.text' of
> > > crypto/built-in.o
> > > `chainiv_module_exit' referenced in section `__ksymtab_gpl' of
> > > crypto/built-in.o: defined in discarded section `.exit.text' of
> > > crypto/built-in.o
> > > `eseqiv_module_exit' referenced in section `__ksymtab_gpl' of
> > > crypto/built-in.o: defined in discarded section `.exit.text' of
> > > crypto/built-in.o
> > > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Does this help?
> > 
> Yup, and doing the same for eseqiv_module_exit completes the fix.
> 
>   LD      arch/arm/boot/compressed/vmlinux
>   OBJCOPY arch/arm/boot/zImage
>   Kernel: arch/arm/boot/zImage is ready

Oh right I should remove the exports since they're in the same
module.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
