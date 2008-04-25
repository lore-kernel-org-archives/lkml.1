Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbYDYIGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbYDYIGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbYDYIFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:05:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758761AbYDYIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:05:34 -0400
Date: Fri, 25 Apr 2008 01:05:34 -0700 (PDT)
Message-Id: <20080425.010534.66319216.davem@davemloft.net>
To: mingo@elte.hu
Cc: linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl,
       ivdoorn@gmail.com
Subject: Re: [build bug] drivers/built-in.o: In function
 `rt2x00leds_resume': : undefined reference to `led_classdev_resume'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080425080033.GA14121@elte.hu>
References: <20080425073504.GA12549@elte.hu>
	<20080425.003947.72853787.davem@davemloft.net>
	<20080425080033.GA14121@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Apr 2008 10:00:33 +0200

> personally i always considered this a Kconfig bug - although it's 
> probably not an easy issue to solve. (what if there are conflicts? What 
> if a driver's select choice disables another driver, without the user 
> being openly aware of this side-effect?)

It definitely is seen as a bug in the context of the alternative,
using 'depend' and then forcing people to spend a lot of time trying
to figure out what magic option they have to enable just to turn
on the driver for their wireless card.

> the patch below fixes it here but it's still kind of a band-aid - what 
> if the Kconfig structure of LEDS get modified - does that have to be 
> propagated to all LEDS using drivers? I dont think this necessity of 
> open-coded dependency resolution is maintainable in the long run.

Yes, that would be the way to work around this.

iwlwifi used LEDS and would need a similar workaround.

Maybe part of the problem is the "if NEW_LEDS" construct used
by drivers/leds/Kconfig?  Perhaps we could make this work if
NEW_LEDS appeared as an explicit dependency of the various
LEDS_* options.

Or, maybe it works to make LEDS_CLASS select NEW_LEDS.

I don't know, this is just a gigantic maze, and I'm just throwing out
random ideas.
