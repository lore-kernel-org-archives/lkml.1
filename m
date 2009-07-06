Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZGFJ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZGFJ7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZGFJ7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:59:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44521 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbZGFJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:59:14 -0400
Date: Mon, 6 Jul 2009 11:00:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Guntsche <mike@it-loops.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090706110014.5cbcc2d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090706074333.GA17276@gondor.apana.org.au>
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com>
	<20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
	<33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
	<20090706074333.GA17276@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So what see here is that on xmit from the network,
> PPP will call pty_write from BH context which eventually leads
> to tty_throttle and the sleep.

That would I fit the symptoms and also explain why some broken versions
of the USB code on embedded devices also exploded with PPP over USB links.

Not however at all easy to fix as it only ever worked in the past on the
"close both eyes, pray and jump" principle of locking.

Added to the todo list for later this week. The pty layer has all sorts
of magic hackery to allow it to call back and forth without going via
internal tty buffering like normal hardware. That may have to die as it
causes other horrible problems too.

Alan
