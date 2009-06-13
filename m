Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZFMH0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZFMH0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFMH0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:26:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58969 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZFMH0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:26:09 -0400
Date: Sat, 13 Jun 2009 09:26:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090613072611.GO11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com> <20090608070503.GB11363@kernel.dk> <c384c5ea0906121505g7ab137dp3bbc202da0d43bcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0906121505g7ab137dp3bbc202da0d43bcd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13 2009, Leon Woestenberg wrote:
> Hello Jens,
> 
> On Mon, Jun 8, 2009 at 9:05 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> > On Sat, Jun 06 2009, Leon Woestenberg wrote:
> >> How can I pass information from the splice_read(), which spawns a hardware
> >> DMA to the pages in my case, to the confirm() hook which is called at some
> >> (random) time in the future?
> >
> > There's a ->private for each pipe_buffer, so you can pass along info on
> > a per-page granularity.
> >
> So, this means in my driver's splice_read(), I must set
> pipe->bufs[i]->private for each 0 <= i < PIPE_BUFFERS?

Yes. There's no way to make it bigger granularity, since you could have
a mix of source pages in the pipe.

-- 
Jens Axboe

