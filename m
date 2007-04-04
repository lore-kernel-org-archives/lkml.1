Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbXDDACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbXDDACN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbXDDACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:02:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45375
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753719AbXDDACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:02:12 -0400
Date: Tue, 03 Apr 2007 17:02:12 -0700 (PDT)
Message-Id: <20070403.170212.02298297.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175644642.10567.31.camel@shinybook.infradead.org>
References: <1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<1175644642.10567.31.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 03 Apr 2007 19:57:22 -0400

> Not really. Non-8250 serial ports, such as the multiport PCI cards from
> Cyclades, Stallion, etc. have had their own device numbers for _years_.
> With hindsight, it was a mistake for pmac_zilog ever to have been called
> 'ttyS0' and to have used the ttyS0 device numbers in the first place.

Sparc does the same thing, it's a common convention and you really
should not break it.

Every powerpc and sparc system out that is using ttyS0 with dynamic
minor numbers being allocated.  I really think this should be
generalized instead of breaking serial on every powerpc machine out
there.  (sparc won't be broken because we have our own copy of
the 8250 driver that does ttyS? minor allocations and keyboard/
mouse serio hookups properly).

