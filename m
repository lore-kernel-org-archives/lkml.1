Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYATQpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYATQpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbYATQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:45:46 -0500
Received: from waste.org ([66.93.16.53]:37164 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbYATQpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:45:45 -0500
Subject: Re: [PATCH] x86:
	fix	unconditional	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Rob Landley <rob@landley.net>
Cc: linux-tiny@selenic.com,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801192259.47063.rob@landley.net>
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <4790D3E3.4060409@free-electrons.com>
	 <1200676219.3835.8.camel@cinder.waste.org>
	 <200801192259.47063.rob@landley.net>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 10:44:48 -0600
Message-Id: <1200847489.13649.6.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 22:59 -0600, Rob Landley wrote:
> On Friday 18 January 2008 11:10:19 Matt Mackall wrote:
> > >     * Disable support for readahead, page writeback, pdflush and swap
> > >       when we have no storage at all (typically booting from an
> > >       initramfs). This corresponds to 69 KB of source code!
> >
> > That'd be nice, yes. It would probably make sense to be able to disable
> > just readahead support when we're working with only solid-state devices.
> 
> Very nice.  From a UI standpoint, shouldn't disabling the block layer take at 
> least some of that out?

There are a number of laptops now that ship with solid-state disks.
These things look like normal IDE block devices to the kernel, but have
zero seek time and zero rotational latency. So here, prefetch is a waste
of memory and probably increases latency on average.

This will also be true for using prefetch on a typical embedded board
using compact flash through an IDE interface controller (extremely
common).

-- 
Mathematics is the supreme nostalgia of our time.

