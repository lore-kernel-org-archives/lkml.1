Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbXDCXzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbXDCXzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXDCXzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:55:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44654
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbXDCXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:55:25 -0400
Date: Tue, 03 Apr 2007 16:55:18 -0700 (PDT)
Message-Id: <20070403.165518.55726194.davem@davemloft.net>
To: paulus@samba.org
Cc: dwmw2@infradead.org, linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Wed, 4 Apr 2007 09:14:20 +1000

> David Woodhouse writes:
> 
> > There are proper device numbers registered for pmac_zilog now. Use them.
> 
> Sigh.  I guess this is inevitable, but IMNSHO this exposes a weakness
> in our serial subsystem.
> 
> The problem is that this means that a user has to know "oh, the serial
> port on my computer is implemented with a Z85C30 chip, therefore it's
> /dev/ttyPZ0 not /dev/ttyS0, like it would be if the designers had used
> a 16C550".
...
> Why should a user know or care about that?  It really should be "it's
> the built-in serial port on my computer therefore it's /dev/ttyS0".

I totally agree with Paul, the onboard serial device should get
ttyS0 regardless of what hardare is used to drive it.

We dish out the minors sequentially on sparc in order to handle
the case of multiple onboard serial controllers of different
types which can happen on sparc.

Generalizing this minor number allocation for ttyS? might be the
best way to handle this.
