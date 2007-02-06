Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXBFF7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXBFF7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXBFF7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:59:10 -0500
Received: from waste.org ([66.93.16.53]:38259 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965360AbXBFF7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:59:09 -0500
Date: Mon, 5 Feb 2007 23:46:12 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206054612.GL16722@waste.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170710272.29759.894.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 09:17:52PM +0000, David Woodhouse wrote:
> On Mon, 2007-02-05 at 08:58 -0800, Linus Torvalds wrote:
> > More importantly, some things that *are* visible probably shouldn't be, or 
> > should perhaps only be in expert mode (aka "EMBEDDED").
> 
> I've heard some fairly stupid abuse of the term 'embedded' in my time,
> but rarely have I heard people daft enough to abuse it to mean 'expert'.
> But yes, that's what we use CONFIG_EMBEDDED for.

I'd be happy to turn this into CONFIG_NONSTANDARD or
CONFIG_EXPERT, which is how I described it in the Kconfig help texts:

menuconfig EMBEDDED
        bool "Configure standard kernel features (for small systems)"
        help
          This option allows certain base kernel options and settings
          to be disabled or tweaked. This is for specialized
          environments which can tolerate a "non-standard" kernel.
          Only use this if you really know what you are doing.

A number of current users are indeed bogus. Stuff like:

config SUPERH
        bool
        default y
        select EMBEDDED

Just because you're using a SuperH board doesn't mean you want to turn
off standard features.

-- 
Mathematics is the supreme nostalgia of our time.
