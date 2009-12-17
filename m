Return-Path: <linux-kernel-owner+w=401wt.eu-S965269AbZLQSpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269AbZLQSpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936640AbZLQSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:45:42 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:57047 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936586AbZLQSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:45:39 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 13:45:39 EST
Date: Thu, 17 Dec 2009 10:35:17 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217183517.GC10707@synopsys.com>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217181718.GA4440@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:17:18AM -0800, Russell King - ARM Linux wrote:
> > It shouldn't as *(int *)0 = 0; might trap.  But if you want to be sure
> > use
> >    __builtin_trap ();
> > instead for the whole sequence (the unreachable is implied then).
> > GCC choses a size-optimal trap representation for your target then.
> 
> How is "size-optimal trap" defined?  The point of "*(int *)0 = 0;" is
> to cause a NULL pointer dereference which is trapped by the kernel to
> produce a full post mortem and backtrace which is easily recognised
> as a result of this code.

With something like __builtin_trap, the compiler knows that your intent
is to cause a trap.  But it's asking for trouble, and for future
flame wars between kernel developers and gcc developers, to put in
sequences that happen to do the right thing if the compiler does
no optimizations whatsoever, but that might be messed up by optimizations
because they are code sequences whose behavior is undefined.

Besides, didn't I see a whole bunch of kernel security patches related
to null pointer dereferences lately?  If page 0 can be mapped, you
suddenly won't get your trap.
