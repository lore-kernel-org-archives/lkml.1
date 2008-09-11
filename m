Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYIKAja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYIKAja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYIKAjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:39:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYIKAjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:39:21 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080911002349.GB14252@gondor.apana.org.au>
References: <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
	 <1221089816.13621.61.camel@macbook.infradead.org>
	 <20080910.164220.56492718.davem@davemloft.net>
	 <20080911002349.GB14252@gondor.apana.org.au>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 00:39:13 +0000
Message-Id: <1221093553.13621.79.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 10:23 +1000, Herbert Xu wrote:
> So I don't want to be in a situation where I install a new kernel,
> find that its wireless driver doesn't function correctly for
> whatever reason (which has happened to me previously at an airport),
> and then not be able to boot back into my old kernel to fix it
> because the firmware has now been overwritten.

Absolutely -- nobody should ever find themselves in that situation.
If a firmware changes in an incompatible way, its filename needs to
change too. The old one should still be available.

> I appreciate the thought on saving disk space.  However, I think
> the safest default is to install firmware (at least those from the
> kernel) into a version-specific directory. 

Even safer would be to have content-addressed firmware. Instead of
requesting it by filename, you request it by its md5sum. That way,
you're _guaranteed_ to have precisely what you expected.

But I think that's a bad idea too. As a general rule firmware isn't, and
shouldn't be, tied intimately to one particular version of the kernel.
It isn't even tied intimately to one particular version of the _driver_.

> Alternatively we should ensure that all firmware have version strings
> embedded in their names (e.g., ipw2200 versions their firmware so they
> would be OK), and that they're kept up-to-date whenever the firmware
> changes.

That's what we are doing already, as you say -- and what we should
always be doing.

And remember, ipw2200 isn't a particularly good example, because it's a
relatively recent driver and thus has always had its firmware shipped
_separately_ from the kernel.

All we're talking about here is the behaviour for the handful of older
drivers which I've recently dragged into this century by converting them
to use request_firmware(). Those drivers, by virtue of their age, are
mostly quite unlikely to receive _any_ kind of firmware update --
especially an update which changes their ABI.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

