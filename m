Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbZJMIby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbZJMIby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZJMIbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:31:53 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:41821
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbZJMIbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:31:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQAACrX00p8qM+u/2dsb2JhbAAI1iiELQQ
X-IronPort-AV: E=Sophos;i="4.44,550,1249228800"; 
   d="scan'208";a="472883263"
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
From: Ben Nizette <bn@niasdigital.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
In-Reply-To: <20091012092331.45d7e71b@bike.lwn.net>
References: <20091010134814.0bac8624@bike.lwn.net>
	 <20091010135343.775e535f@bike.lwn.net>
	 <1255327904.5347.79.camel@ben-desktop>
	 <20091012092331.45d7e71b@bike.lwn.net>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 19:31:09 +1100
Message-Id: <1255422669.5347.281.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 09:23 -0600, Jonathan Corbet wrote:
> On Mon, 12 Oct 2009 17:11:44 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> 
> > Back to this patch though, the gpio names have to come from the platform
> > code via some platform_data for the gpio chip [1], the driver then looks
> > up that pre-defined name to find the gpio number.  Why not just pass the
> > gpio number straight to the end device driver through platform_data and
> > bypass the middle-man?
> 
> That's true in a situation where you've one One Platform to Bind Them
> All, yes.  But if you have (say) GPIOs provided by a PCI-connected
> peripheral which are needed in (say) a camera driver, there is no one
> platform which can manage all those GPIO numbers.  In particular, I've
> done a driver for viafb-based GPIOs; these devices can show up in any
> of a number of x86-based systems.  I honestly don't know why it would
> make sense to try to hardware numbers to these GPIOs when using names
> and dynamic numbering is so much more flexible - and we are already
> tracking the names.
> 
> Perhaps it would make sense to implement a proper namespace layer for
> GPIOs rather than continuing to grow something which evidently sneaked
> in through the back door.  Until that's done, though, I think this
> patch is useful.  But it it's really unwanted I'll find some other way.
> 

Fair enough; I hadn't seen gpio controllers on such buses before but
that makes sense.  If the naming information isn't coming from platform
code but from some driver itself this seems fairly sane.

If gpios are going to be named, and it seems they are, then personally
I'd like to see the names field of struct gpio_chip go and a proper
namespace layer inserted.  Something which allows gpio_name() and
gpio_lookup() and decentralises that responsibility would be nice (the
chip could call gpio_name itself if it has reason).  That code could be
common to all gpio framework implementations.

But a) I don't have the hours to do this myself and b) it's really
David's call, I'm just an interested bystander :-)

	--Ben



