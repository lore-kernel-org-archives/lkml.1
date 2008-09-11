Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYIKAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYIKAYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYIKAYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:24:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:34091 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbYIKAYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:24:05 -0400
Date: Thu, 11 Sep 2008 10:23:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911002349.GB14252@gondor.apana.org.au>
References: <1221088512.13621.58.camel@macbook.infradead.org> <20080910.162423.40167601.davem@davemloft.net> <1221089816.13621.61.camel@macbook.infradead.org> <20080910.164220.56492718.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910.164220.56492718.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 04:42:20PM -0700, David Miller wrote:
>
> For example, Herbert Xu (CC:'d) told me that because of this directory
> usage, his wireless card couldn't find it's firmware with current
> kernels.

Actually my complaint is still theoretical.

It's about firmware that's closely tied to the driver and where a
driver may not operate at all with a firmware of the wrong version.
There are wireless drivers which have version dependencies, e.g.,
newer ipw2200 drivers often require newer firmware which may not
be backwards compatible.

So I don't want to be in a situation where I install a new kernel,
find that its wireless driver doesn't function correctly for
whatever reason (which has happened to me previously at an airport),
and then not be able to boot back into my old kernel to fix it
because the firmware has now been overwritten.

I appreciate the thought on saving disk space.  However, I think
the safest default is to install firmware (at least those from the
kernel) into a version-specific directory.  Alternatively we should
ensure that all firmware have version strings embedded in their
names (e.g., ipw2200 versions their firmware so they would be OK),
and that they're kept up-to-date whenever the firmware changes.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
