Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXBFPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXBFPgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXBFPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:36:13 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:34363 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXBFPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:36:12 -0500
Date: Wed, 7 Feb 2007 00:34:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Mackall <mpm@selenic.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206153413.GA10167@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Matt Mackall <mpm@selenic.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <20070206054612.GL16722@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206054612.GL16722@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 11:46:12PM -0600, Matt Mackall wrote:
> I'd be happy to turn this into CONFIG_NONSTANDARD or
> CONFIG_EXPERT, which is how I described it in the Kconfig help texts:
> 
> menuconfig EMBEDDED
>         bool "Configure standard kernel features (for small systems)"
>         help
>           This option allows certain base kernel options and settings
>           to be disabled or tweaked. This is for specialized
>           environments which can tolerate a "non-standard" kernel.
>           Only use this if you really know what you are doing.
> 
> A number of current users are indeed bogus. Stuff like:
> 
> config SUPERH
>         bool
>         default y
>         select EMBEDDED
> 
> Just because you're using a SuperH board doesn't mean you want to turn
> off standard features.
> 
The only thing bogus is the CONFIG_EMBEDDED use itself, if it were only
limited to turning options off, you'd be correct, but both PCI and IDE
use it for other things. We specifically wanted it for IDE in this case.

I'd be quite happy to see CONFIG_EMBEDDED separated entirely from the
"advanced/expert/screwing aunt tillie" selection menu, or whatever we're
choosing to call it these days. Then we wouldn't have to deal with these
confusing defconfigs that expose far more than most users are going to
care about.

There are a number of other architectures that do this too, so it may be
worth separating so we can finally get rid of the confusion.
