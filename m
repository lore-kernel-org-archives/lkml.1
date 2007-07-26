Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbXG0AN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbXG0AN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXG0ANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:13:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42589
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbXG0ANT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:13:19 -0400
Date: Thu, 26 Jul 2007 16:14:41 -0700 (PDT)
Message-Id: <20070726.161441.38711978.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: matthew@wil.cx, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
References: <20070726201355.GP19275@parisc-linux.org>
	<20070726.152352.70218024.davem@davemloft.net>
	<alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2007 16:04:42 -0700 (PDT)

> Quite frankly, my preference would be (a) followed by (e) or (f), and 
> (b)-(d) are in my opinion the worst of the lot with no upsides at all (and 
> (b) in particular is pretty much _guaranteed_ to break existing setups).

I look at some cases, such as EHEA on powerpc which is a pretty
modern driver written by not clueless folks, and wonder if they
do it because they know the IRQ is non-shared, they know their
interrupt handler is insanely simple and short, and just want to
avoid the overhead of that sti()/cli() in the caller.

All the EHEA interrupt handler does is unconditionally set a state bit
and schedule a softirq, then return.

The powerpc folks do delayed IRQ enable/disable using software state,
but perhaps these drivers were written before that.
