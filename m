Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbXGWSdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbXGWSdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765264AbXGWScr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:32:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:51621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764277AbXGWScq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:32:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
Date: Mon, 23 Jul 2007 20:32:28 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org> <Pine.LNX.4.64.0707232338260.22796@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232338260.22796@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707232032.28815.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 20:14:52 Satyam Sharma wrote:
> On Mon, 23 Jul 2007, Linus Torvalds wrote:
> 
> > On Mon, 23 Jul 2007, Satyam Sharma wrote:
> > >
> > > * The "I" constraint modifier is applicable only to immediate-value operands,
> > >   and combining it with "r" is bogus.
> > 
> > This is wrong too.
> > 
> > The whole point of a "Ir" modifier is to say that the instruction takes 
> > *either* an "I" or an "r".
> 
> Yup, sorry about this one, Andi pointed this out earlier. But the "I"
> must still go I think, for the third reason in that changelog -- it
> unnecessarily limits the bit offset to 0..31, but (at least from the
> comment up front in that file) we do allow arbitrarily large @nr (upto
> 255, of course, these instructions won't take anything greater than that).


As HPA pointed out that would risk not being correctly assembled by at 
least some binutils versions

 
> > Andrew - the ones I've looked at were all wrong. Please don't take this 
> > series.
> 
> I think I'll rescind the series anyway, a lot of patches turned out to
> be wrong -- some due to mis-reading / incorrect gcc docs, others due to
> other reasons ... this was just something I did thinking of as a cleanup
> anyway, so I don't intend to push or correct this or anything.

cpumask_t/nodemask_t bitmap optimizations would be useful.

-Andi

