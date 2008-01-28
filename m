Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYA1Lli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYA1Lli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYA1Ll3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:41:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62669 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756858AbYA1Ll2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:41:28 -0500
Date: Mon, 28 Jan 2008 12:41:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@maxim.org.za, linux@bohmer.net, coldwell@redhat.com,
       marc.pignat@hevs.ch, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH -mm v4 7/9] atmel_serial: Add DMA support
Message-ID: <20080128124125.5c4e0a31@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080128022000.82ac86ab.akpm@linux-foundation.org>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
	<1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
	<20080126220200.368742e7.akpm@linux-foundation.org>
	<20080128105909.0fa8a431@dhcp-252-066.norway.atmel.com>
	<20080128022000.82ac86ab.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 02:20:00 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 28 Jan 2008 10:59:09 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > > ho-hum.  The generic uart buffer-handling code does ringbuffers the wrong
> > > way.  Maybe it has to handle non-power-of-two buffer sizes.
> > 
> > Hmm...I don't understand. What does it do wrong?
> 
> An faq ;) If the buffer size is a power-of-two it's better to allow the
> head and tail indices wrap through 0xffffffff and only mask them when
> subscripting.  It ends up faster (usually) and you can use all of the
> elements of the buffer (rather than all-1) and you get nice things like:
> 
> is_empty = (head == tail)
> is_full = (tail - head == size)
> nr_items_in_ring = (tail - head)

Ok, that makes sense. Thanks for explaining. Not sure if want to start
improving things right now, although I'm pretty sure the circ stuff
can't handle non-power-of-two buffer size currently so it should be
possible.

> > > All those uart_circ_*() macros reference their arg more than once and ... 
> > > you know the deal.
> > 
> > Yeah. Would you like a patch that inline-ifies <linux/circ.h>?
> 
> uh, if you're feeling especially keen.  We have bigger problems than this.

Well, if you put it like that; no, not really.

I'll post a fix for the other things you pointed out shortly.

Haavard
