Return-Path: <linux-kernel-owner+w=401wt.eu-S1764480AbZAOOGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764480AbZAOOGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZAOOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:06:28 -0500
Received: from ee.oulu.fi ([130.231.61.23]:35929 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbZAOOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:06:28 -0500
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 09:06:27 EST
Date: Thu, 15 Jan 2009 15:40:55 +0200
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Mihai =?utf-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: b44 - swapper: page allocation failure
Message-ID: <20090115134055.GA15551@ee.oulu.fi>
References: <20090115111537.GA994@gondor.apana.org.au> <200901151527.43646.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901151527.43646.mihai.dontu@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 03:27:43PM +0200, Mihai Donțu wrote:
> > > A friend of mine just booted 2.6.28 and when someone else tried to send
> > > something to him over ssh (scp), the transfer failed and the following
> > > appeared in dmesg:
> > You missed the all important order line before the stack trace.
> Right, sorry for that. Here it is:
> swapper: page allocation failure. order:0, mode:0x21
> > If it's order 0, then you're just out of memory, if it's greater
> > than order 0, then either you're using jumbo frames or b44 is
> > broken.
> It is order zero, but he's not out of memory. He has just booted 2.6.28 (no X, 
> no thing), has 3GB of RAM and 2GB of swap.
b44 uses GFP_DMA bounce buffers in some situations (x86_64 with > 1GB of
memory would do the trick I think, as does x86 with 4:4 memory split),
and that's a very limited resource (Memory < 16MB ). 

Lovely hardware feature requiring nasty workarounds
(the chip can't do DMA for addresses > 1GB).

Maybe something else sucks up GFP_DMA memory with 2.6.28?
