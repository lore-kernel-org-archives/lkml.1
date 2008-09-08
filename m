Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYIHXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYIHXnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYIHXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:43:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYIHXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:43:12 -0400
Date: Mon, 08 Sep 2008 16:43:05 -0700 (PDT)
Message-Id: <20080908.164305.140831737.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: david-b@pacbell.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220916186.8074.84.camel@localhost.localdomain>
References: <1220914847.8074.81.camel@localhost.localdomain>
	<20080908.160441.124972717.davem@davemloft.net>
	<1220916186.8074.84.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 08 Sep 2008 18:23:06 -0500

> But realistically that's all we need.  Our RTC is controlled by two
> calls into firmware: a get and a set; nothing else.  We don't have the
> docs to get at the clock without the firmware calls.

I wrote RTC layer drivers on sparc64 that make the firmware calls in
the Niagara system case, exactly like your case.

Really, this is the way to do this.

Since you're not reading what I implemented, I'll read it for you :-/

See drivers/rtc/rtc-sun4v.c, that's the driver

Code in arch/sparc64/kernel/time.c creates and registers the
appropriate platform_device object once the correct system type is
detected, and then rtc-sun4v.c attaches when such objects have been
registered.

Likewise for all the other RTC types that can be found on Sparc machines.
