Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbZLQTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbZLQTim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965471AbZLQTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:38:40 -0500
Received: from mail2.shareable.org ([80.68.89.115]:56039 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464AbZLQTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:38:39 -0500
Date: Thu, 17 Dec 2009 19:38:26 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Joe Buck <Joe.Buck@synopsys.COM>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217193826.GE362@shareable.org>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <20091217183517.GC10707@synopsys.com> <20091217190613.GB4440@n2100.arm.linux.org.uk> <20091217191401.GD10707@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217191401.GD10707@synopsys.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Buck wrote:
> On Thu, Dec 17, 2009 at 11:06:13AM -0800, Russell King - ARM Linux wrote:
> > On Thu, Dec 17, 2009 at 10:35:17AM -0800, Joe Buck wrote:
> > > Besides, didn't I see a whole bunch of kernel security patches related
> > > to null pointer dereferences lately?  If page 0 can be mapped, you
> > > suddenly won't get your trap.
> > 
> > Page 0 can not be mapped on ARM kernels since the late 1990s, and this
> > protection is independent of the generic kernel.
> > 
> > Milage may vary on other architectures, but that's not a concern here.

It does not trap on at least one ARM-nommu kernel...

> I don't understand, though, why you would want to implement a generally
> useful facility (make the kernel trap so you can do a post-mortem
> analysis) in a way that's only safe for the ARM port.

The patch under discussion, which led to these questions and Cc
gcc@gcc.gnu.org, is specific to the ARM architecture and that is
Russell's focus, as ARM kernel maintainer.

But yes, the whole principle of how to trap and whether it's safe to
follow a null pointer dereference with __builtin_unreachable() applies
to all the other architectures too.

-- Jamie
