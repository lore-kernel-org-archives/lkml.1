Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXLDUiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXLDUiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXLDUh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:37:56 -0500
Received: from waste.org ([66.93.16.53]:60030 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbXLDUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:37:56 -0500
Date: Tue, 4 Dec 2007 14:36:36 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204203636.GB19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204195021.GB7259@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:50:21PM -0500, Theodore Tso wrote:
> On Tue, Dec 04, 2007 at 12:02:37PM -0600, Matt Mackall wrote:
> > On Tue, Dec 04, 2007 at 04:55:02PM +0000, Alan Cox wrote:
> > > > cryptographically strong stream it'll provide when /dev/random is
> > > > tapped? In principle, this'd leave more entropy available for
> > > > applications that really need it, especially on platforms that don't
> > > > generate a lot of entropy in the first place (servers).
> > > 
> > > 
> > > As reported about a month ago, the evidence is that the /dev/random
> > > stream is not cryptographically strong. Collecting uuids generated from
> > > the kernel uuid random generator from the random generator in the kernel
> > > shows abnormal patterns of duplicates.
> > 
> > Pointer, please.
> 
> Alan, are you sure you're not talking about Helge Deller's attempt to
> push a Time-based UUID generator into the kernel because you can get
> duplicates from the current userspace library?
> 
> I've not heard of *any* claim where the kernel uuid random generator
> has been returning duplicates.

Before we added proper locking, it could theoretically happen on SMP
with readers in lockstep. That was early 2.6.

The only serious critique I know of is the Gutterman-Pinkas-Reinman
paper which was a year out of date before publication. Now that
another year has passed, perhaps I should respond to it..

-- 
Mathematics is the supreme nostalgia of our time.
