Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbXLQRgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbXLQRgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbXLQRgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:36:36 -0500
Received: from THUNK.ORG ([69.25.196.29]:44677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbXLQRgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:36:35 -0500
Date: Mon, 17 Dec 2007 12:36:23 -0500
From: Theodore Tso <tytso@mit.edu>
To: John Reiser <jreiser@BitWagon.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071217173623.GC7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766A40D.4080804@BitWagon.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 08:30:05AM -0800, John Reiser wrote:
> >>[You have yet to show that...]
> >>There is a path that goes from user data into the pool.
> 
> Note particularly that the path includes data from other users.
> Under the current implementation, anyone who accesses /dev/urandom
> is subject to having some bytes from their address space being captured
> and mixed into the pool.

Again, you haven't *proven* this yet.

> A direct attack (determining the specific values or partial values
> of some captured bytes) is not the only way to steal secrets.
> An indirect attack, such as traffic analysis, also may be effective.
> 
> Here is one idea.  Use output from /dev/urandom to generate a random
> permutation group.  Analyze the group: determine all its subgroups, etc.
> If the structure of those groups has different properties depending
> on the captured bytes, even after SHA1 and folding and twisting,
> then that may be enough to help steal secrets.

Generate a random permutation group *how*?  This sounds suspiciously
like "reverse the polarity of the neutron flow" technobabble to me.
What are you going to compare the groups against?  What subgroup?  How
big of a group do you think it is going to be?  So you really think
the output of SHA is going to produce a group with subgroups?

> Indirect attacks may be subject to "exponent doubling."  The state
> modulo 2**(2n) may correspond to a system of 2**n congruences
> in 2**n variables.  So a property modulo 2**n might be hoisted to a
> related property modulo 2**(2n).  This might make 2**1024 seem to be
> not so big.

> A completely formal
> Goedel-numbering proof often has a formal checker that is logarithmic
> in the length of the proof.  If such a logarithmic property applies
> every once in a while to /dev/urandom, then that might be enough.

References, please and exactly how this would apply to the situation
at hand?  This sounds like math babble to me, and I have taken enough
abstract algebra and other math class that this sounds suspiciously to
me like the sort of stuff that Star Trek actors make up when the
script says "insert technobabble here".  Of course, I'm not a math
major, so I'm willing to accept the possibility that you know what
you're talking about --- but I do know enough that I should be able to
evaluate any proofs and math papers you want to throw at me.

						- Ted

