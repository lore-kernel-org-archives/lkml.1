Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXK0Bf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXK0Bf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbXK0Bfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:35:48 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4360 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbXK0Bfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:35:47 -0500
Date: Tue, 27 Nov 2007 09:35:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joe Perches <joe@perches.com>
Cc: Denis Cheng <crquan@gmail.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, dengxw@163.com,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from <linux/kernel.h> instead
Message-ID: <20071127013540.GA793@gondor.apana.org.au>
References: <20071126143939.GB28022@gondor.apana.org.au> <1196098095-8995-1-git-send-email-crquan@gmail.com> <1196100104.31590.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196100104.31590.11.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:01:44AM -0800, Joe Perches wrote:
> On Tue, 2007-11-27 at 01:28 +0800, Denis Cheng wrote:
> > -static void hexdump(unsigned char *buf, unsigned int len)
> > -{
> > -	while (len--)
> > -		printk("%02x", *buf++);
> > -
> > -	printk("\n");
> > -}
> 
> #define hexdump(buf, len) \
> 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, \
> 	               (buf), (len), false)
> 
> requires no other changes.

Yes that's a good idea.  Denis could you do another patch with
this, preferably as a static inline function? That way you don't
even need to worry about test_aead.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
