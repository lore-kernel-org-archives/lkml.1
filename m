Return-Path: <linux-kernel-owner+w=401wt.eu-S1764358AbYBUBwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764358AbYBUBwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYBUBwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:52:43 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:54980 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbYBUBwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:52:42 -0500
Date: Thu, 21 Feb 2008 10:52:33 +0900 (JST)
Message-Id: <20080221.105233.41199605.nemoto@toshiba-tops.co.jp>
To: marc.pignat@hevs.ch
Cc: hskinnemoen@atmel.com, david-b@pacbell.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_spi: support zero length transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200802201855.02605.marc.pignat@hevs.ch>
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>
	<200802201855.02605.marc.pignat@hevs.ch>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 18:55:01 +0100, Marc Pignat <marc.pignat@hevs.ch> wrote:
> > A spi transfer with zero length is not invalid.  Such transfer can be
> > used to achieve delay before first CLK edge after chipselect assertion.
> How long will be that delay?

My funny custom device requires 100us or so.  Unfortunately atmel_spi
can not use such a slow bitrate.

> If they are really users of that kind of thing, this should be fixed by adding
> a "delay_us_before_xfer" field in the  struct spi_transfer.

Yes, it would be an another way to achieve it.  But as long as zero
length transfer is legal on this API, I don't want to add other
fields.

> Have you tested it? I think if you start a transfer with 0 len, the ENDRX bit
> will never rise, however, I'm not sure about this.

Yes.  I tested it on AT91SAM9260 and it seems ENDRX rises soon.
Though it can be possible to avoid starting DMA for zero length
transfer, I think it is not worth to optimize for such a rare case.

---
Atsushi Nemoto
