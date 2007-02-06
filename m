Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXBFGW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXBFGW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXBFGW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:22:27 -0500
Received: from waste.org ([66.93.16.53]:41237 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXBFGW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:22:26 -0500
Date: Tue, 6 Feb 2007 00:09:37 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206060937.GM16722@waste.org>
References: <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <20070206010958.GA31809@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206010958.GA31809@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 08:09:58PM -0500, Theodore Tso wrote:
> On Mon, Feb 05, 2007 at 11:21:34PM +0000, David Woodhouse wrote:
> > But Alan makes a reasonable suggestion -- we could work around this in
> > the tools too. 
> 
> I wouldn't call it "work around this" in the tools.  It's a useful
> feature we can add in the tools for developers who aren't men enough
> to use "sed/grep" pipelines.  :-)
> 
> But I have to agree with Linus here that we should be optimizing the
> tools for people who know how to compile the kernel, but who aren't
> necessarily familiar with all of the hidden dependencies in the
> literally hundreds of config options in the kernel tree.  In reality,
> you want to make it easy to turn on *or* off any arbitrary config
> option, and to understand what you need to do so you can turn an
> arbitrary config option on or off.  If that means tools enhancements,
> so be it.  

With apt (or presumably with yum), you can happily apt-remove
a package that nothing else depends on. If you remove something that
other things depend on, you get a list of those things and opportunity
to force it (with a -f flag, for instance). If you ask for a package
that has other dependencies, it automatically pulls all those things
in unless there's a conflict. In which case you can force it again.

There's no reason we shouldn't be able to do exactly that with config
symbols in Kconfig-land. The only difference is that we've got
slightly different semantics for our "depend" keyword. Things which
don't have their "depend" requirements met aren't offered as options.
Whereas "select" is "automatically pull in dependencies"
apt/yum-style.

While we're at it, it would also be nice to be able to do:

$ kconfig enable ACPI
CONFIG_ACPI conflicts with CONFIG_APM
$ kconfig enable -F ACPI
disabling CONFIG_APM
$ kconfig disable SCSI
CONFIG_USB_STORAGE depends on CONFIG_SCSI
$ kconfig disable -f SCSI
disabling USB_STORAGE
$ make

-- 
Mathematics is the supreme nostalgia of our time.
