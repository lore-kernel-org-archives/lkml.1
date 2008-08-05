Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYHEKBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYHEKBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbYHEKA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:00:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:49757 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755042AbYHEKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,309,1215414000"; 
   d="scan'208";a="367965995"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <20080804141916.GC11415@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <20080804141916.GC11415@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 05:59:11 -0400
Message-Id: <1217930351.1613.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 22:19 +0800, Herbert Xu wrote:
> On Mon, Aug 04, 2008 at 05:35:07AM -0400, Austin Zhang wrote:
> >
> > +config CRYPTO_CRC32C_INTEL
> > +        tristate "CRC32c INTEL hardware acceleration"
> > +        select CRYPTO_HASH
> 
> You need some sort of a dependency here.  See what the other
> assembly algorithms do it.
> 
> Cheers,
How about:
+config CRYPTO_CRC32C_INTEL
+        tristate "CRC32c INTEL hardware acceleration"
+       depends on X86
+        select CRYPTO_ALGAPI
+        help
+          In Intel processor with SSE4.2 supported, the processor will
......

It should only depend on X86.

