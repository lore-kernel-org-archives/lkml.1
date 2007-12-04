Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXLDTuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXLDTuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLDTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:50:48 -0500
Received: from thunk.org ([69.25.196.29]:45411 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXLDTur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:50:47 -0500
Date: Tue, 4 Dec 2007 14:50:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204195021.GB7259@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204180237.GU19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 12:02:37PM -0600, Matt Mackall wrote:
> On Tue, Dec 04, 2007 at 04:55:02PM +0000, Alan Cox wrote:
> > > cryptographically strong stream it'll provide when /dev/random is
> > > tapped? In principle, this'd leave more entropy available for
> > > applications that really need it, especially on platforms that don't
> > > generate a lot of entropy in the first place (servers).
> > 
> > 
> > As reported about a month ago, the evidence is that the /dev/random
> > stream is not cryptographically strong. Collecting uuids generated from
> > the kernel uuid random generator from the random generator in the kernel
> > shows abnormal patterns of duplicates.
> 
> Pointer, please.

Alan, are you sure you're not talking about Helge Deller's attempt to
push a Time-based UUID generator into the kernel because you can get
duplicates from the current userspace library?

I've not heard of *any* claim where the kernel uuid random generator
has been returning duplicates.

						- Ted

P.S.  Probably the right approach for Helge is to create a daemon
started at boot time with privileges to write the appropriate state
file to prevent duplicates across reboots, and then to change the uuid
library to use the daemon if it is available (accessed via a Unix
domain socket), or to use its existing algorithm (which is fine unless
you have multiple threads wanting to generate large numbers of UUIDs
per second in parallel), and you want to use time-based UUID's because
they have better b-tree characteristics when you use them as indexes
into a database.
