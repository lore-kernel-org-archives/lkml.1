Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbZFHHFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbZFHHFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZFHHFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:05:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45554 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZFHHFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:05:02 -0400
Date: Mon, 8 Jun 2009 09:05:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090608070503.GB11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06 2009, Leon Woestenberg wrote:
> Hello Jens,
> 
> in the spirit of splice-and-dice I continue asking questions until I grasp this.
> 
> On Mon, May 11, 2009 at 9:22 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> > So if your design is allocating the pages in the ->splice_read()
> > handler and initiating IO to these pages, then you need to provide a
> > suitable ->confirm() hook that can wait on this IO to complete if
> > needed.
> 
> When the driver's splice_read() is called, the kernel wants the driver to
> allocate pages and later check that they are filled with data through the
> confirm() hook. Is that correct?

Correct.

> How can I pass information from the splice_read(), which spawns a hardware
> DMA to the pages in my case, to the confirm() hook which is called at some
> (random) time in the future?

There's a ->private for each pipe_buffer, so you can pass along info on
a per-page granularity.

-- 
Jens Axboe

