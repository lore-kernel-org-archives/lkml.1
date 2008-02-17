Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYBQOQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYBQOQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYBQOQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:16:38 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:65448 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbYBQOQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:16:37 -0500
Date: Sun, 17 Feb 2008 23:16:55 +0900 (JST)
Message-Id: <20080217.231655.59465217.anemo@mba.ocn.ne.jp>
To: david-b@pacbell.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: spi transfer with zero length
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200802161058.49473.david-b@pacbell.net>
References: <20080216.230232.25478328.anemo@mba.ocn.ne.jp>
	<200802161058.49473.david-b@pacbell.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 10:58:48 -0800, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 16 February 2008, Atsushi Nemoto wrote:
> > Hi.  Is it legal to use zero for 'len' field of struct spi_transfer?
> > I mean, len=0, tx_buf=rx_buf=NULL, delay_usecs!=0.
> 
> Yes that should work ... it's uncommon, but not illegal.  Some
> controller drivers may even handle that right!
> 
> If the delay were zero and cs_change didn't indicate a need to
> briefly deselect the chip, it might make sense to reject such
> a NOP transfer.  But that's not the case you identify.

Thank you.  I suppose spi-bitbang can handle that right.  Then I'm
going to fix drivers if it cannot handle such case.

> > Some SPI devices need slightly long delay before first CLK edge after
> > CS assertion.
> 
> For future reference ... could you identify a few such devices,
> and say what "long" is relative to the clock period?
> 
> Some folk have just slowed down the clock in such cases, but
> that's rather sub-optimal.

Well, the device I have is so special custom one implemented by PIC or
something.  It needs 100us or so with 200ns clock period.  Slowing
down might be an another solution but some spi driver cannot use such
a slow bitrate (~10KHz).

> > To achieve this, I think inserting using a zero length 
> > transfer before real transfers.  But it seems some drivers do not
> > handle this case properly.
> 
> Feel free to submit patches fixing those bugs.

OK, if I had enough time to make a patch for uptodate version of the
driver ;)

---
Atsushi Nemoto
