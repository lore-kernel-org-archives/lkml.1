Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbXKDLTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbXKDLTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 06:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXKDLTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 06:19:41 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46751 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143AbXKDLTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 06:19:40 -0500
Date: Sun, 4 Nov 2007 11:18:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Christoph Lameter wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> 
> > Neither of us has yet posted a correct patch which applies to 2.6.23
> > and 2.6.22.  I'm testing your 2.6.24-rc patch overnight, and if that's
> > fine then one of us will post the version for -stable.  I thought I'd
> > better leave that to you, after I've reported back.
> 
> Ok.

That testing went fine, as you'd expect.  Your diffstat is certainly
nicer than mine (corrected for SlabDebug) would be.  I expect you'll
go ahead with yours.

But I remain slightly uneasy about it: I do think your original
instinct, in putting in the code you're now removing, was good.

In a low memory situation, when several tasks pile up to allocate
the same resource, we'd usually free back all but the first, rather
than depleting free memory even more than necessary.  That you were
doing before, now you take the simpler way out and don't bother.

I've no evidence that this is a significant issue: just mention
it in case it gives you second thoughts e.g. was there a concrete
scenario, other than instinct, which led you to put in that code
originally?

Hugh
