Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYDTJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYDTJrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 05:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYDTJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 05:47:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47617
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbYDTJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 05:47:02 -0400
Date: Sun, 20 Apr 2008 02:47:04 -0700 (PDT)
Message-Id: <20080420.024704.02026708.davem@davemloft.net>
To: ivdoorn@gmail.com
Cc: mingo@elte.hu, linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl
Subject: Re: [build bug] drivers/built-in.o: In function
 `rt2x00leds_resume': : undefined reference to `led_classdev_resume'
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804201131.01504.IvDoorn@gmail.com>
References: <20080420081302.GA11954@elte.hu>
	<20080420.020557.231970202.davem@davemloft.net>
	<200804201131.01504.IvDoorn@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivo van Doorn <ivdoorn@gmail.com>
Date: Sun, 20 Apr 2008 11:31:00 +0200

> Not sure about it, but doesn't LEDS_CLASS depend on NEW_LEDS ?
> Which would make selecting LEDS_CLASS broken when NEW_LEDS isn't enabled?

True, what an awful dependency chain.

NEW_LEDS requires HAS_IOMEM.  This is to handle platforms like
S390 and UM.

But I think this protection is overboard.  Specific drivers
might need IOMEM functionality, but the basic infrastructure
does not.

All of the core infrastrucure and generic LEDS facilities, including
NEW_LEDS, LEDS_CLASS, and LEDS_TRIGGERS, don't need the IOMEM
protection.

And neither do the LED device drivers, they already each have a
depenency for a specific platform.

You could even imagine a hypervisor based LED driver that a platform
like S390, which does not enable HAS_IOMEM, might want to support
under this infrastructure.

I think NEW_LEDS can be completely eliminated.
