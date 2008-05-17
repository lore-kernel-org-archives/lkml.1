Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbYEQUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbYEQUGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbYEQUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:06:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbYEQUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:05:57 -0400
Date: Sat, 17 May 2008 13:05:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Chris Peterson" <cpeterso@cpeterso.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last
 few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080517130535.02d45372@infradead.org>
In-Reply-To: <a24804730805171254i2a37da61mb47280db7b330ed5@mail.gmail.com>
References: <20080515142154.0595e475@core>
	<482C7DA3.1090809@garzik.org>
	<482C953A.4080205@garzik.org>
	<87abirytxj.fsf@basil.nowhere.org>
	<20080516105635.6cb1f505@core>
	<482D5FC5.2070103@firstfloor.org>
	<20080516121239.GA9627@gondor.apana.org.au>
	<482DB568.1040704@firstfloor.org>
	<20080517010136.GA15102@gondor.apana.org.au>
	<482EBAA8.3040506@firstfloor.org>
	<a24804730805171254i2a37da61mb47280db7b330ed5@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 12:54:02 -0700
"Chris Peterson" <cpeterso@cpeterso.com> wrote:

> Andi, can you please clarify what you mean by "auto-feeding
> /dev/urandom only" and "only get blocking /dev/random with the user
> daemon"? Are you suggesting that the kernel provides /dev/urandom and
> a userspace daemon (e.g. EGD) provides /dev/random?
> 
> Also, if crypto apps like ssh and openssl use on "insecure"
> /dev/urandom, then who actually relies on /dev/random?

gpg does for key generation

> For comparison,
> FreeBSD does not even (AFAIK) have /dev/urandom. FreeBSD's /dev/random
> is nonblocking (like Linux's /dev/urandom) and includes network
> entropy.
> 

I think the big kicker is the difference between a session key (short
lived) and a "real" key such as a gpg key that lives for a long time
and is used for multile sessions and with different users (in crypto
speak, Alice uses the same random key for Bob, Charlotte and David and
potentially for a long time). For a session key, urandom is very likely
an acceptable compromise; there's only so much data it's used for.
For long term keys I can totally see why /dev/random is used instead.

So both have value, just in different circumstances.
