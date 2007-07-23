Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbXGWWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbXGWWfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXGWWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:35:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXGWWfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:35:45 -0400
Date: Mon, 23 Jul 2007 15:34:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070723153437.4fc62253.akpm@linux-foundation.org>
In-Reply-To: <200707231815.38124.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707231419.13182.rgetz@blackfin.uclinux.org>
	<20070723131553.2943861f.akpm@linux-foundation.org>
	<200707231815.38124.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 18:15:37 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Mon 23 Jul 2007 16:15, Andrew Morton pondered:
> > This code would be
> > simpler if it did not attempt to read more than one char at a time.  It
> > will be plenty fast enough.
> 
> When systems have NMI kick off due to power failure, and you want to grab the 
> log buffer to write it to flash before power really dies - every cycle 
> counts.
> 
> A single function which does the copy as a loop (existing) is going to be much 
> faster than the overhead of 1024 function calls to copy the last k.

I'd expect the overhead of the (fully-cached) instructions to be
insignificant compared to the time to write to flash?

> > The magical interpretation of len isn't very nice. 
> 
> There are lots of places in the kernel which have magic in them :)

Lots of the kernel is pretty crappy.  One of our main tools for fixing that is to
ensure that new stuff is non-crappy.

