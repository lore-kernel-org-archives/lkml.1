Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXBFQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXBFQy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXBFQy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:54:29 -0500
Received: from waste.org ([66.93.16.53]:44278 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXBFQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:54:28 -0500
Date: Tue, 6 Feb 2007 10:41:18 -0600
From: Matt Mackall <mpm@selenic.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Theodore Tso <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206164118.GP10108@waste.org>
References: <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <20070206010958.GA31809@thunk.org> <20070206060937.GM16722@waste.org> <45C8A70F.9090507@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C8A70F.9090507@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 11:04:31AM -0500, Bill Davidsen wrote:
> >There's no reason we shouldn't be able to do exactly that with config
> >symbols in Kconfig-land. The only difference is that we've got
> >slightly different semantics for our "depend" keyword. Things which
> >don't have their "depend" requirements met aren't offered as options.
> >Whereas "select" is "automatically pull in dependencies"
> >apt/yum-style.
> 
> Perhaps this is because there is a lacking keyword. The depends controls 
> visibility, perhaps a "requires" could be used to provide advisory 
> information which mean "these other things will be turned on if you 
> build this feature."

"require" is a bad name as it's a synonym of "depend".

> >While we're at it, it would also be nice to be able to do:
> >
> >$ kconfig enable ACPI
> >CONFIG_ACPI conflicts with CONFIG_APM
> >$ kconfig enable -F ACPI
> >disabling CONFIG_APM
> >$ kconfig disable SCSI
> >CONFIG_USB_STORAGE depends on CONFIG_SCSI
> >$ kconfig disable -f SCSI
> >disabling USB_STORAGE
> >$ make
> >
> I think depends and select provide this now, the postulated "requires" 
> might make building the trees easier.

The above is all about having a scriptable command line interface so
that people don't need the broken sed + make oldconfig thing.

-- 
Mathematics is the supreme nostalgia of our time.
