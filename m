Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYHDQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYHDQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYHDQQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:16:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58147 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:16:35 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate
	CRC32c	algorithm by new crypto API.
From: Chris Mason <chris.mason@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dwmw2@infradead.org, austin_zhang@linux.intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <E1KQ2D2-0003Fn-00@gondolin.me.apana.org.au>
References: <E1KQ2D2-0003Fn-00@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 12:14:56 -0400
Message-Id: <1217866496.29139.75.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 23:42 +0800, Herbert Xu wrote:
> Chris Mason <chris.mason@oracle.com> wrote:
> >
> >>From a performance point of view I'm probably reading the crypto API
> > code wrong, but it looks like my choices are to either have a long
> > standing context and use locking around the digest/hash calls to protect
> > internal crypto state, or create a new context every time and take a
> > perf hit while crypto looks up the right module.
> 
> You're looking at the old hash interface.  New users should use the
> ahash interface which was only recently added to the kernel.  It
> lets you store the state in the request object which you pass to
> the algorithm on every call.  This means that you only need one
> tfm in the entire system for crc32c.
> 

Great to hear, that solves my main concern then.  There is still the
embedded argument against needing all of crypto api just for libcrc32c.

It does make sense to me to have a libcrc32c that does the HW detection
and uses HW assist when present, and just have the cypto api call that.

-chris


