Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZIOPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZIOPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZIOPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:45:24 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:57202 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZIOPpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:45:24 -0400
Date: Wed, 16 Sep 2009 00:45:25 +0900 (JST)
Message-Id: <20090916.004525.74746264.anemo@mba.ocn.ne.jp>
To: julia@diku.dk
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.64.0909150701170.11392@ask.diku.dk>
References: <20090914.003321.160496287.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.64.0909132113520.31000@ask.diku.dk>
	<Pine.LNX.4.64.0909150701170.11392@ask.diku.dk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 07:03:42 +0200 (CEST), Julia Lawall <julia@diku.dk> wrote:
> > +out_pdev:
> > +	platform_device_put(pdev);
> > +out_gpio:
> > +	gpio_remove(&iocled->chip);
> 
> I just noticed that the prototype of gpio_remove has __must_check
> I don't think there is anything to check here; since the thing is not 
> fully initialized here, it is unlikely to be busy.  Should there be (void) 
> in front of it?

The void casting does not silence the warning.  How about this?

	if (gpiochip_remove(&iocled->chip))
		return;

In general, memory leak would be less serious than crash or data
corruption ;)

---
Atsushi Nemoto
