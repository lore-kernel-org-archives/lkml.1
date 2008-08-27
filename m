Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYH0FOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYH0FOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 01:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYH0FOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 01:14:10 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55806 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYH0FOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 01:14:09 -0400
Subject: Re: [PATCH] virtio_blk: use noop elevator by default
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <20080826143900.GM20055@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080826143900.GM20055@kernel.dk>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Wed, 27 Aug 2008 14:14:07 +0900
Message-Id: <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 16:39 +0200, Jens Axboe wrote: 
> On Tue, Aug 26 2008, Fernando Luis Vázquez Cao wrote:
> > Hi Rusty,
> > 
> > Would it make sense to use noop by default? After all we do not know
> > what is behind the backend driver and the hypervisor is likely to do its
> > own scheduling anyway. I guess this is the reason the Xen guys took this
> > approach.
> > 
> > What do you think about the patch below?
> 
> I plan to include some variant of disk profiling for 2.6.28 which will
> let eg CFQ turn off idling for such device types, I think that is a
> better solution.

Hi Jens,

That is good news. With the proliferation of intelligent disk
controllers and SSDs, the disk profiling approach seems to be the right
way to go in general and I think it was badly needed.

>From your example my wild guess is that disk profiling will be a I/O
controller-specific auto-tuning feature, not a new functionality of the
generic elevator layer. Is this interpretation correct? Would it make
sense in some cases to change elevators automatically depending on the
characteristics of the underlying device instead (e.g. we might not need
any of the extra features CFQ provides, for example)?

I would like to take a look at those patches so I peeked into your git
tree, but I could not find them (I probably chose the wrong branches).
Are they accessible through your kernel.org's git repository?

Thanks!

Fernando

