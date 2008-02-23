Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbYBWCzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbYBWCzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYBWCz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:55:29 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:37470 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752652AbYBWCz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:55:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DdCr4gTKi+We7CAyclTtsxr6SAZ9tfQXQfc+1/P9gnTO00F4I6MSH/E3pqeKvzhasvcrI6jEr2FYCVR5avxt+k8Zk9f8m4z4QyCDwyoQrmFnv/2hHz7vGQqwVO5x48b9+olm6aLQ1unNsup/rVTMVWhzVn4N5AU7Hca6KoOBfLk=  ;
X-YMail-OSG: qeovLQAVM1mGXk6sv32bYEQgkx.SoBR3PNIS0aGHapmVS8Xn
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Date: Fri, 22 Feb 2008 18:55:25 -0800
User-Agent: KMail/1.9.6
Cc: anemo@mba.ocn.ne.jp, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200802221030.32263.marc.pignat@hevs.ch>
In-Reply-To: <200802221030.32263.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221855.25892.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > David, do you think writing 0 bytes is a valid use of this API?
> > 
> > Just a zero byte transfer ... no, though it depends what you mean
> > by "valid".  (I'm not sure I'd expect all controller drivers to
> > reject such requests.)  That has no effect on bits-on-the-wire,
> > and would make trouble for various DMA engines.
>
> So, the behaviour is undefined, something between 'crash my dma engine',
> 'assert chip select and wait some time', or 'do_nothing'...

No, it's fully defined.  "Crash my engine" is not OK.  The delay
is controlled by transfer.delay_usecs ... possibly zero, which is
best viewed as a degenerate case.


> Is this kind of device so common that we need to do all that work? or can we
> leave it as is (verified to work only with atmel_spi)?

You can't avoid testing each combination of SPI protocol driver
and SPI master controller driver you rely on ... especially when
protocol tweaking options (cs_change, delay_usecs, bits_per_word,
etc) are used at the per-transfer level.  This driver stack isn't
as readily tested as, say, USB.

However, protocol drivers should be able to rely on controller
drivers to reject requests that they don't even try to handle;
that's basic.

- Dave

