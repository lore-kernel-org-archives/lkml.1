Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYIKHoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYIKHoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYIKHoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:44:03 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56965 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYIKHoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:44:01 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <20080910.162423.40167601.davem@davemloft.net>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 09:44:28 +0200
Message-Id: <1221119068.6309.8.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > It's definitely not something we should be doing upstream though.
> 
> So you think it's ok that every Debian user has to learn this
> magic incantation just to use current kernels?
> 
> I don't think it's nice to break things like this on people,
> especially such a large group.  Getting this stuff to work is hard
> enough, and we're just putting yet another barrier into the situation
> and that can only mean less testers and contributors.
> 
> I do know several people who aren't testing and contributing because
> the whole firmware shakeup is so bolixed and they really are exasperated
> after spending hours trying to get it to work.

it is that the Debian maintainer screwed this up. Upstream never
promoted kernel versioned directories for the firmware. I had a long
discussion with Dave about it at OLS and using the kernel version is
just plain wrong. The driver maintainers should version the firmware if
they break it in an API incompatible way.

To shed some light into the problem with Debian/Ubuntu. They install the
firmware in /lib/firmware/`uname -r`/ and everytime they bump their ABI
number, they have to install all the firmware again. This is just
braindead. Their udev script actually checks /lib/firmware first and
then the kernel versioned directory. So that is just fine.

Problem comes when installing let say 2.6.27 since then the firmware
will be looked up in /lib/firmware/ and /lib/firmware/2.6.27/ and
actually it will not be found. Since it is in /lib/firmware/2.6.26-xx/
or something similar.

So having the kernel install everything in /lib/firmware works just fine
with every distro. However looking for firmware that is not shipped with
the kernel, we have a problem since Debian/Ubuntu just not installs it
in the right directory. And there is nothing the kernel can do about it
since it will not touch firmware it doesn't ship. The distro has to fix
their firmware or the users have to place a copy in /lib/firmware/ where
it actually should have been in the first place.

Regards

Marcel


