Return-Path: <linux-kernel-owner+w=401wt.eu-S2992747AbXDDImH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992747AbXDDImH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992752AbXDDImH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:42:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38829
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992747AbXDDImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:42:04 -0400
Date: Wed, 04 Apr 2007 01:41:55 -0700 (PDT)
Message-Id: <20070404.014155.58456511.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404075244.GB3440@flint.arm.linux.org.uk>
References: <1175663999.2932.8.camel@shinybook.infradead.org>
	<20070403.225006.119275067.davem@davemloft.net>
	<20070404075244.GB3440@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Wed, 4 Apr 2007 08:52:44 +0100

> On Tue, Apr 03, 2007 at 10:50:06PM -0700, David Miller wrote:
> > From: David Woodhouse <dwmw2@infradead.org>
> > Date: Wed, 04 Apr 2007 01:19:59 -0400
> > 
> > > I don't see why that 'should' be the case. Certainly it _isn't_ the case
> > > on most supported platforms -- we have separate device numbers, and
> > > names, for most types of ports. There's only one or two drivers which
> > > abuse ttySn for anything other than 8250 ports.
> > 
> > sunsu, sunzilog, pmac_zilog, sunsab, etc.
> > 
> > The list is longer than you think.  In fact the convention is
> > very well established.
> 
> ... and has never ever worked along side the existing 8250 (or serial)
> driver - therefore it can also be viewed as a long standing BUG.

I forked the 8250 driver for Sparc, that's what sunsu is, and it works
along side sunzilog and sunsab, which also use the ttyS0 major, just
fine.

They also setup the console correctly, and even make sure it matches
what the user selected in the firmware environment variables.

It can be made to work.
