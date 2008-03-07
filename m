Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYCGSOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYCGSOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYCGSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:14:13 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:28127 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbYCGSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vO8Di6y64rvPpPzzCKflgzu/0gO2N3AuySC47524cgBD1SS9F6T57EokEGAtcMPPrrsWX9kwJNBgxch9mvtBsGwarOkvjJS71XICzBUJQLo3YO2wzNdNmAh+r7mJK03EjsKgvfI1rnX7mZYv0e4n7LKaCNjcy84ix0VQCNgGGfo=
Message-ID: <e9c3a7c20803071014s6388b7b2l12f217bfdff5caa3@mail.gmail.com>
Date: Fri, 7 Mar 2008 11:14:07 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Cc: "Milan Broz" <mbroz@redhat.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Alasdair G Kergon" <agk@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
In-Reply-To: <20080222123423.GA12678@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
	 <47BC0DA9.1030607@redhat.com>
	 <20080220172449.GD27726@gondor.apana.org.au>
	 <47BC67CE.9070407@redhat.com>
	 <20080220175819.GA28246@gondor.apana.org.au>
	 <20080222123423.GA12678@gondor.apana.org.au>
X-Google-Sender-Auth: 9d1ae26e49c4ce0a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 5:34 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>  Does this patch fix the problem?
[..]

I believe this is in mainline as 76fc60a2 "[CRYPTO] skcipher: Move
chainiv/seqiv into crypto_blkcipher module".  With a iop13xx_defconfig
 I get:

`chainiv_module_exit' referenced in section `.init.text' of
crypto/built-in.o: defined in discarded section `.exit.text' of
crypto/built-in.o
`chainiv_module_exit' referenced in section `__ksymtab_gpl' of
crypto/built-in.o: defined in discarded section `.exit.text' of
crypto/built-in.o
`eseqiv_module_exit' referenced in section `__ksymtab_gpl' of
crypto/built-in.o: defined in discarded section `.exit.text' of
crypto/built-in.o
make: *** [.tmp_vmlinux1] Error 1

Reverting this (git show 76fc60a2 | patch -p1 -R) gets me back to a
working build.:

arm-none-linux-gnueabi-gcc --version
arm-none-linux-gnueabi-gcc (CodeSourcery Sourcery G++ Lite 2007q1-21)
4.2.0 20070413 (prerelease)

--
Dan
