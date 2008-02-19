Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbYBSOvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbYBSOvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYBSOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:51:06 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:60496 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbYBSOvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:51:04 -0500
Date: Tue, 19 Feb 2008 23:51:23 +0900 (JST)
Message-Id: <20080219.235123.07645009.anemo@mba.ocn.ne.jp>
To: hskinnemoen@atmel.com
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] atmel_spi clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080218234918.3d09022a@siona>
References: <20080218.231243.41197917.anemo@mba.ocn.ne.jp>
	<200802181157.57299.david-b@pacbell.net>
	<20080218234918.3d09022a@siona>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 23:49:18 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > > CLK     ______________________|~|___|~~~|___|~~~|___|~~~|___
> > 
> > ... and at T1 CPOL is changed??  That's wrong.  There should
> > never be a partial clock period while a chipselect is active.
> > While it's inactive, sure -- no chip should care.
> 
> ...but what I'm afraid of is that since we're using GPIO chipselects,
> the controller may _think_ that no chip is selected and change the
> clock polarity just before it would pull the chipselect low if we were
> using automatic chipselects...

Yes.  That's I suppose.

> If that's the case, it would be a bit strange if it actually helped to
> initialize all the CSRn registers, but it would also offer us a nice
> workaround...

I suppose the clock state of the AT91 just follows _last_ transfer.
My patch (setting all CSRn.POL for next transfer) was based on that
assumption.

> Atsushi, do you by any chance have debugging enabled? That would
> explain the long delay from CS activation to the change of clock
> polarity. Compared to printk() the DMA setup takes almost no time at
> all.

No, I did not enabled debugging.

> If you can confirm that my patch helps, I think that's the one we want
> in mainline.

Unfortunately I had no time to try it today.  Hopefully tomorrow...

---
Atsushi Nemoto
