Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCaDpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCaDpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXCaDpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:45:42 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4393 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965105AbXCaDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:45:41 -0400
Date: Sat, 31 Mar 2007 13:45:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to advance through scatterlist
Message-ID: <20070331034513.GA926@gondor.apana.org.au>
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com> <460DBC4C.1060602@trash.net> <20070331021437.GA31298@gondor.apana.org.au> <20070331031129.GA1784@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331031129.GA1784@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 08:11:29PM -0700, Greg KH wrote:
> 
> Is this an "add-on" patch, or a replacement one?

This is an add-on.  In case you want a replacement, here it is:

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 35172d3..0f76175 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -91,6 +91,8 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		memcpy_dir(buf, vaddr, len_this_page, out);
 		scatterwalk_unmap(vaddr, out);
 
+		scatterwalk_advance(walk, len_this_page);
+
 		if (nbytes == len_this_page)
 			break;
 
@@ -99,7 +101,5 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 
 		scatterwalk_pagedone(walk, out, 1);
 	}
-
-	scatterwalk_advance(walk, nbytes);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
