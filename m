Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbZLTFWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbZLTFWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZLTFWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:22:53 -0500
Received: from 1wt.eu ([62.212.114.60]:52801 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZLTFWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:22:52 -0500
Date: Sun, 20 Dec 2009 06:22:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>, Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH] new kqueue API v.08
Message-ID: <20091220052202.GE32739@1wt.eu>
References: <1261179026.16900.42.camel@wall-e> <20091219113609.GB9321@basil.fritz.box> <1261265115.26268.11.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261265115.26268.11.camel@wall-e>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 12:25:15AM +0100, Stefani Seibold wrote:
> Am Samstag, den 19.12.2009, 12:36 +0100 schrieb Andi Kleen:
> > I like the basic idea of a type safe FIFO.
> > 
> > > #define	DYNAMIC
> > > #ifdef DYNAMIC
> > > static DECLARE_KFIFO_PTR(test[1], int);
> > > #else
> > > static DECLARE_KFIFO(test[1], int, FIFO_SIZE);
> > 
> > The [1] looks weird.  Is that really needed and what does it mean?
> > The callers below don't seem to use it like an array.
> 
> I am a lazy girl. This is only for convenient, because i don't want to
> write always kfifo_....(&test...). Using an array of [1] provide the
> pointer automaticly. Of course you can also write
> 
> static DECLARE_KFIFO(test, int, FIFO_SIZE);
> 
> and then call the kfifo macros with the address of the variable.

So you want test[0] then, not test[1]. Or I'm missing something.

Also, the subject of your mail was a bit misleading, it was talking
about "kqueue" (which is the equivalent of epoll on BSD systems),
while everywhere in the code we see kfifo. I think you simply changed
the name recently for kfifo in fact.

Willy

