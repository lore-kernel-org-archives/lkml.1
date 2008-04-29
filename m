Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYD2C4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYD2C4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYD2C4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:56:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYD2C4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:56:22 -0400
Date: Mon, 28 Apr 2008 19:54:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-Id: <20080428195455.6e07cb8d.akpm@linux-foundation.org>
In-Reply-To: <200804281628.14004.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	<20080428134649.44cf239c.akpm@linux-foundation.org>
	<200804281628.14004.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 16:28:13 -0700 David Brownell <david-b@pacbell.net> wrote:

> > If we had a strcmp() variant which treats a \n in the first arg as a \0
> > the above would become
> > 
> > 	if (sysfs_streq(buf, "high"))
> > 		status = gpio_direction_output(gpio, 1);
> > 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> > 		status = gpio_direction_output(gpio, 0);
> > 	else if (sysfs_streq(buf, "in"))
> > 		status = gpio_direction_input(gpio);
> 
> That would indeed be better.  Maybe I should whip up a sysfs
> patch adding that, and have this depend on that patch.  (I've
> CC'd Greg in case he has comments on that...)

Yes, it would be a standalone patch.  The sort which generates oceans of
useful feedback ;) The sort which also generates hundreds of
use-new-toy-to-clean-up-old-code patches for me to merge :(

> Alternatively:  strict_streq(), analogy to strict_strto*()?

Yeah, I couldn't think of a decent name.  I do think it should return true
on finding a match so callers don't need to use !  or ==0.  So its name
shouldn't look anything like "strcmp".

