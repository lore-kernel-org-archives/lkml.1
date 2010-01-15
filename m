Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778Ab0AOBDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0AOBDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 20:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839Ab0AOBDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:03:23 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:23753 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0AOBDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:03:21 -0500
Date: Thu, 14 Jan 2010 17:03:15 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Julia Lawall <julia@diku.dk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       N??meth M??rton <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality (was Re: [PATCH] uwb: make USB device id constant)
Message-ID: <20100115010315.GA29093@hexapodia.org>
References: <4B4C297A.5090405@freemail.hu> <4B4C9ED9.60905@csr.com> <4B4CAA15.4030200@freemail.hu> <4B4DDFDB.2000408@s5r6.in-berlin.de> <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 04:38:22PM +0100, Julia Lawall wrote:
> > When you write a changelog, keep your audience in mind:
> > 
> >   - Developers, distributors, advanced users want to learn what a new
> >     release brings.  (OK, this audience stops reading after the initial
> >     headline of a "make XYZ table constant" commit.  Which just means
> >     that all the rest of the changelog is fluff that can be omitted.)
> > 
> >   - Developers, maintainers etc. want to understand years later why the
> >     code is how it is.  (For them, a commit like that is sufficiently
> >     described by the headline as well.)
> 
> Not surprisingly, I don't agree about this one.  I recall a series of 
> patches that said something like "used a script to change down/up to 
> mutexes".  The script wasn't included, not all down/ups were changed to 
> mutexes, and in short there was no understandable trace of why the change 
> was made where it was.  Perhaps that is a pathological example, but it is 
> not necessarily obvious in advance what needs precise documentation and 
> what does not.

I agree with Julia, at least in some cases.  Having the semantic patch
present when it's 5 or 10 lines long and clearly explains the intended
change is incredibly valuable for review.  Sometimes, the script is the
clearest way to indicate your intent -- I'd much rather see a changelog
that says "s/FOO/BAR/g" than "Change FOO to BAR everywhere".

For example, look at 5d66fe92.  The semantic patch is blissfully,
incredibly clear.  It makes the sun shine down through the clouds, the
birds sing, and the kzalloc align.  It's 10 lines long and is quite
intuitive and explanatory.  In that case, I think it's clear that the
spatch is worth the changelog space it takes up, even though the
changelog is larger than the diff by quite a margin.

On the other hand, the patch that started this thread is a
counterexample, to me.  The correctness of the constification is only
tenuously attested, for me at least, by the semantic patch.  The spatch
is really long compared to the diff, and complicated to read.

So, I think it's a balancing act.  I've been very happy to see spatches
in some of Julia's posts, and I've also found some of the more
voluminous spatches in changelogs to be more noise than signal.

-andy
