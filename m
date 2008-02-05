Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYBEAFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYBEAFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYBEAFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:05:42 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:23733 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757263AbYBEAFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:05:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aOssz8Dz2ur+be4WqwJLXVk4WAJ/2WQSurUleQnI0nOmjO6QuCe0oZ6aPVKRqY1tbFTn4crPKy2g6SpjHn9IVVA8VX7WwBJto0bzg7iZ69RDC0qNAbN5l2fnFTn75p+90MbAgbhtij0tmINFJ6tE2KJFvYJ6aF2DbvxQhcLPVTo=  ;
X-YMail-OSG: vvdWEVsVM1m.fQ5ovJJAvldpGDfJ1.ydkT8NudngMRvg6gAJv88gkLv8Bbh1ctOXvxTLsG4iMQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>, willy@linux.intel.com
Subject: Re: [git pull] SLUB updates for 2.6.25
Date: Tue, 5 Feb 2008 11:05:11 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com> <200802051010.49372.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802041542570.4774@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802041542570.4774@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051105.12194.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 10:47, Christoph Lameter wrote:
> On Tue, 5 Feb 2008, Nick Piggin wrote:
> > > erk, sorry, I misremembered.   I was about to merge all the patches we
> > > weren't going to merge.  oops.
> >
> > While you're there, can you drop the patch(es?) I commented on
> > and didn't get an answer to. Like the ones that open code their
> > own locking primitives and do risky looking things with barriers
> > to boot...
>
> That patch will be moved to a special archive for
> microbenchmarks. It shows the same issues like the __unlock patch.

Ok. But the approach is just not so good. If you _really_ need something
like that and it is a win over the regular non-atomic unlock, then you
just have to implement it as a generic locking / atomic operation and
allow all architectures to implement the optimal (and correct) memory
barriers.

Anyway....


> > Also, WRT this one:
> > slub-use-non-atomic-bit-unlock.patch
> >
> > This is strange that it is unwanted. Avoiding atomic operations
> > is a pretty good idea. The fact that it appears to be slower on
> > some microbenchmark on some architecture IMO either means that
> > their __clear_bit_unlock or the CPU isn't implemented so well...
>
> Its slower on x86_64 and that is a pretty important arch. So
> I am to defer this until we have analyzed the situation some more. Could
> there be some effect of atomic ops on the speed with which a cacheline is
> released?

I'm sure it could have an effect. But why is the common case in SLUB
for the cacheline to be bouncing? What's the benchmark? What does SLAB
do in that benchmark, is it faster than SLUB there? What does the
non-atomic bit unlock do to Willy's database workload?
