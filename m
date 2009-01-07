Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbZAGMw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbZAGMw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZAGMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:52:15 -0500
Received: from 1wt.eu ([62.212.114.60]:1212 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZAGMwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:52:14 -0500
Date: Wed, 7 Jan 2009 13:52:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jarek Poplawski <jarkao2@gmail.com>,
       Changli Gao <xiaosuo@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107125201.GB6307@1wt.eu>
References: <20081224152841.GB13113@1wt.eu> <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124034.GB31255@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107124034.GB31255@ioremap.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:40:34PM +0300, Evgeniy Polyakov wrote:
> On Wed, Jan 07, 2009 at 01:35:04PM +0100, Jens Axboe (jens.axboe@oracle.com) wrote:
> > Irregardless of that particular oddity, I don't think this is the right
> > path to take at all. We need to delay the pipe buffer consumption until
> > the appropriate time.
> 
> As a proof of concept we can put a delayed work_struct into the buffer
> and only release its content after some timeout big enough (like one
> second or so) for the hardware to actually transmit its buffers.

Evgeniy, I'd like to understand something related to our apparent lack of
knowledge of when the data is effectively transmitted. If we're focusing
on the send part, I can't understand why I never reproduce the corruption
when the data source is a file or loopback, but I only see it when the source
is an ethernet interface. How is it possible that a problem affecting only
the send side is so much selective about the source ? And in fact, why can't
we apply the same workflow for outgoing data for both types of sources ? It
seems to me that the page is released at the right time when sending a file,
and I don't see why we cannot apply the same principle when splicing between
sockets.

Please excuse me for my blattant ignorance in this area, as I once said, I
could not completely follow the whole splice process between tcp_splice_read()
and the moment the data leaves the machine. Also, I failed to understand what
linear data means. It seems to me this is the parts that are memcpy'd, but I'm
not sure.

Thanks,
Willy

