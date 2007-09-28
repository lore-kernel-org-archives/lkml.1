Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbXI2Mxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbXI2Mxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXI2Mxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:53:32 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:29349 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756131AbXI2Mxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:53:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=VytvAiGxGLQVdAQYI5iuo937fl6kbVyAe5CMkPzutzyNdN91DA6CWtGmvlR4Klv46ZtBF/wbHxMsmufJnnsehVU2YN8BykKpoRlnY52fOpWTAMQZsv6JIsVVEN4nyDivGcCmSEUpR9Zp4WDI4qeggWtGn5shD/p61deU3N8Zr1c=  ;
X-YMail-OSG: dLsLgh4VM1npSB.26NEhRKnY051jVWvIX_K_iRjwEab8E9kHhQR8s5DCba7JOMTlbH_py_X5Hw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Sat, 29 Sep 2007 06:22:10 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <1191003950.18147.85.camel@lappy> <Pine.LNX.4.64.0709281133570.5397@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709281133570.5397@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709290622.11019.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 04:41, Christoph Lameter wrote:
> On Fri, 28 Sep 2007, Peter Zijlstra wrote:
> > memory got massively fragemented, as anti-frag gets easily defeated.
> > setting min_free_kbytes to 12M does seem to solve it - it forces 2 max
> > order blocks to stay available, so we don't mix types. however 12M on
> > 128M is rather a lot.
>
> Yes, strict ordering would be much better. On NUMA it may be possible to
> completely forbid merging. We can fall back to other nodes if necessary.
> 12M is not much on a NUMA system.
>
> But this shows that (unsurprisingly) we may have issues on systems with a
> small amounts of memory and we may not want to use higher orders on such
> systems.
>
> The case you got may be good to use as a testcase for the virtual
> fallback. Hmmmm... Maybe it is possible to allocate the stack as a virtual
> compound page. Got some script/code to produce that problem?

Yeah, you could do that, but we generally don't have big problems allocating
stacks in mainline, because we have very few users of higher order pages,
the few that are there don't seem to be a problem.
