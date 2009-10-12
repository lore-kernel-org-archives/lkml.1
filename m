Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZJLPYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZJLPYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZJLPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:24:10 -0400
Received: from vena.lwn.net ([206.168.112.25]:39496 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZJLPYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:24:09 -0400
Date: Mon, 12 Oct 2009 09:23:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ben Nizette <bn@niasdigital.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Message-ID: <20091012092331.45d7e71b@bike.lwn.net>
In-Reply-To: <1255327904.5347.79.camel@ben-desktop>
References: <20091010134814.0bac8624@bike.lwn.net>
	<20091010135343.775e535f@bike.lwn.net>
	<1255327904.5347.79.camel@ben-desktop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 17:11:44 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> Back to this patch though, the gpio names have to come from the platform
> code via some platform_data for the gpio chip [1], the driver then looks
> up that pre-defined name to find the gpio number.  Why not just pass the
> gpio number straight to the end device driver through platform_data and
> bypass the middle-man?

That's true in a situation where you've one One Platform to Bind Them
All, yes.  But if you have (say) GPIOs provided by a PCI-connected
peripheral which are needed in (say) a camera driver, there is no one
platform which can manage all those GPIO numbers.  In particular, I've
done a driver for viafb-based GPIOs; these devices can show up in any
of a number of x86-based systems.  I honestly don't know why it would
make sense to try to hardware numbers to these GPIOs when using names
and dynamic numbering is so much more flexible - and we are already
tracking the names.

Perhaps it would make sense to implement a proper namespace layer for
GPIOs rather than continuing to grow something which evidently sneaked
in through the back door.  Until that's done, though, I think this
patch is useful.  But it it's really unwanted I'll find some other way.

Thanks,

jon
