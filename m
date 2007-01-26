Return-Path: <linux-kernel-owner+w=401wt.eu-S1030815AbXAZIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030815AbXAZIUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030819AbXAZIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:20:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50119
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030815AbXAZIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:20:21 -0500
Date: Fri, 26 Jan 2007 00:20:20 -0800 (PST)
Message-Id: <20070126.002020.48528097.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1169788181.3593.250.camel@shinybook.infradead.org>
References: <1169785150.3593.231.camel@shinybook.infradead.org>
	<Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
	<1169788181.3593.250.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 26 Jan 2007 13:09:40 +0800

> My question was about _how_ you think this should be achieved in this
> particular case. You didn't like the suggestion that we should put your
> new special-case hack into the resource code... where/how _do_ you
> suggest that it's done, so that we can protect those poor driver authors
> from the number zero?

Just set some high bit in the arch code that creates the resources,
then when you interpret them in arch code simply clear the bit.

That's effectively what happens on sparc64 since all non-memory
physical addressing occurs at the top of the physical address
space.  But you don't need that layout, you can fake it.
