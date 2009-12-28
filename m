Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZL1QIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZL1QIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZL1QIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:08:38 -0500
Received: from www84.your-server.de ([213.133.104.84]:40845 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZL1QIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:08:38 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091228145749.GD4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e>  <20091228145749.GD4994@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 17:08:30 +0100
Message-ID: <1262016510.12656.25.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 15:57 +0100 schrieb Andi Kleen:
> On Mon, Dec 28, 2009 at 08:42:16AM +0100, Stefani Seibold wrote:
> > Anyway, I ack all your patches, expect the "2/6 Make kfifo_in atomic"
> > which will break my future work.
> 
> That's the most important patch. Without those kfifo_in() is 
> unusable for any record size not a power of two imho.
> 

Yes, i understand. That is why i rewrote the API. But if we apply this
patch, the future type safe interface will be broken. Because the
current implementation is based on the "unsigned char" type. And for
this types it works as expected.

kfifo_in() and kfifo_out() process max. elements (not in bytes) and
returns the number of processed elements. For processing a single
element the new kfifo_put(), kfifo_get(), kfifo_peek() are introduced.

The new macro based kfifo is type based. So for example a

struct foo {
	int	a;
	short	b;
};

static DECLARE_KFIFO(bar, struct foo, 32);
 
will reserve 32 elements of the type "struct foo". So the power of two
is in the new implementation not the number of bytes, it is in the
meaning of elements.

So please draw back this patch, you will get exactly what you want and
need in the next release. I have now a clean, slim and fast
implementation. All what i need is a review and some ack's

Stefani


