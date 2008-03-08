Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYCHDm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYCHDm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 22:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYCHDmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 22:42:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:48845 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYCHDmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 22:42:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,465,1199692800"; 
   d="scan'208";a="216207187"
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
From: Dan Williams <dan.j.williams@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <mbroz@redhat.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
In-Reply-To: <20080308012438.GA24236@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
	 <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au>
	 <47BC67CE.9070407@redhat.com> <20080220175819.GA28246@gondor.apana.org.au>
	 <20080222123423.GA12678@gondor.apana.org.au>
	 <e9c3a7c20803071014s6388b7b2l12f217bfdff5caa3@mail.gmail.com>
	 <20080308012438.GA24236@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 20:42:44 -0700
Message-Id: <1204947764.27096.4.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 18:24 -0700, Herbert Xu wrote:
> On Fri, Mar 07, 2008 at 11:14:07AM -0700, Dan Williams wrote:
> >
> > I believe this is in mainline as 76fc60a2 "[CRYPTO] skcipher: Move
> > chainiv/seqiv into crypto_blkcipher module".  With a iop13xx_defconfig
> >  I get:
> >
> > `chainiv_module_exit' referenced in section `.init.text' of
> > crypto/built-in.o: defined in discarded section `.exit.text' of
> > crypto/built-in.o
> > `chainiv_module_exit' referenced in section `__ksymtab_gpl' of
> > crypto/built-in.o: defined in discarded section `.exit.text' of
> > crypto/built-in.o
> > `eseqiv_module_exit' referenced in section `__ksymtab_gpl' of
> > crypto/built-in.o: defined in discarded section `.exit.text' of
> > crypto/built-in.o
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Does this help?
> 
Yup, and doing the same for eseqiv_module_exit completes the fix.

  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready

Thanks,
Dan


