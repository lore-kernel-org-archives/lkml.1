Return-Path: <linux-kernel-owner+w=401wt.eu-S2992732AbXDDIMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992732AbXDDIMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992731AbXDDIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:12:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49452
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992732AbXDDIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:12:11 -0400
Date: Wed, 04 Apr 2007 01:12:08 -0700 (PDT)
Message-Id: <20070404.011208.120446173.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175666635.2932.17.camel@shinybook.infradead.org>
References: <1175663999.2932.8.camel@shinybook.infradead.org>
	<17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	<1175666635.2932.17.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 04 Apr 2007 02:03:54 -0400

> On Wed, 2007-04-04 at 15:53 +1000, Paul Mackerras wrote:
> > It 'should' be the case because that is what is easiest for users and
> > makes most sense from a user's point of view.
> 
> I really don't buy that argument.

I do.

David, do this.  Fly to Portland, drive over to Linus's house, once he
lets you in, tell him to walk up to his computer and run 'cat' on the
primary serial port.  Do all of this before he reads this thread. :-)

What device name do you think he will type in?

Will he type a different device name on his PowerPC box than he will
on his x86 systems?

I think he will type /dev/ttyS0 in both cases, and it won't be because
he knows what kind of serial port controller is in either machine.

It's that simple.

Your ARM example holds zero water because that platform has all kinds
of weird devices so people there are used to all kinds of non-standard
conventions and naming.

Try desktop systems that lots of users actually use.  Ask them what
the serial device file is.  Ask them if they had to know what
serial controller they have in their computer in order to figure
that out.

> That's what you get when you abuse device numbers belonging to
> another driver.

No, it's what you get whan drivers of the same major number do
not cooperate with minor number allocations.

Add a notion of onboard serial controllers and a properly coordinated
minor number allocation system for /dev/ttyS0 if you want to solve this.

As it stands your patch is a non-starter because it breaks a user
visible API, and people's machines won't bootup or have a console
any longer.  Or, if the powerpc machine is at Alan's house his
model trains might stop working :-)
