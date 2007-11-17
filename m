Return-Path: <linux-kernel-owner+w=401wt.eu-S1765946AbXKQT0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765946AbXKQT0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbXKQT01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:26:27 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59438 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbXKQT00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:26:26 -0500
Date: Sat, 17 Nov 2007 20:28:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       akpm@linux-foundation.org
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071117192806.GB8568@uranus.ravnborg.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 10:15:52AM -0800, Arjan van de Ven wrote:
> Hi,
> 
> today, all oopses contain a version number of the kernel, which is nice
> because the people who actually do bother to read the oops get this
> vital bit of information always without having to ask the reporter in
> another round trip.
> 
> However, WARN_ON() right now lacks this information; the patch below
> adds this. This information is essential for getting people to use
> their time effectively when looking at these things; in addition, it's
> essential for tools that try to collect statistics about defects.
> 
> Please consider, maybe even for 2.6.24 since its so simple and
> important for long term quality

With this change we will see zillions of files being rebuild each
time we pick up another kernel version from git and friends.

For me it looks like this right now:
#define UTS_RELEASE "2.6.24-rc2-g99fee6d7-dirty"

committing my local changes made it look like:
#define UTS_RELEASE "2.6.24-rc2-g99fee6d7"

The above change will trigger a rebuild of all files
that reference UTS_RELEASE as will all WARN_ON users.

And this is with the default configuration.

So if we want this then we want to push that change to a
seperate function so we rebuild less files for simple changes.

	Sam
