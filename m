Return-Path: <linux-kernel-owner+w=401wt.eu-S970500AbXILS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970500AbXILS2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXILS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:27:52 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:25139 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753838AbXILS1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:27:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l7kmalVuO5bU6takOEqv5w5JNERf7J/lgHR6gnsr73jzTFGBNIubED5zYMuNDEqf/tNPavr1X2SQDmB7M5FfSL+SKWqPyVH7zTztvNUsRNJV7qbjntkozIy7qd2RrRKbmo5xNRH7wwLmZMDCvc4mJi6k0qhZNoJNe6oSqFEwW1k=  ;
X-YMail-OSG: EltWgVMVM1nOsWeLoe0z5G6hQzCE.j1TxqcCC4gadh6T4.UJ
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Wed, 12 Sep 2007 12:46:08 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111617.03586.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121246.08833.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 10:00, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > Yes. I think we differ on our interpretations of "okay". In my
> > interpretation, it is not OK to use this patch as a way to solve VM or FS
> > or IO scalability issues, especially not while the alternative approaches
> > that do _not_ have these problems have not been adequately compared or
> > argued against.
>
> We never talked about not being able to solve scalability issues with this
> patchset. The alternate approaches were discussed at the VM MiniSummit and
> at the VM/FS meeting. You organized the VM/FS summit. I know you were
> there and were arguing for your approach. That was not sufficient?

I will still argue that my approach is the better technical solution for large
block support than yours, I don't think we made progress on that. And I'm
quite sure we agreed at the VM summit not to rely on your patches for
VM or IO scalability.


> > So even after all this time you do not understand what the fundamental
> > problem is with anti-frag and yet you are happy to waste both our time
> > in endless flamewars telling me how wrong I am about it.
>
> We obviously have discussed this before and the only point of asking this
> question by you seems to be to have me repeat the whole line argument
> again?

But you just showed in two emails that you don't understand what the
problem is. To reiterate: lumpy reclaim does *not* invalidate my formulae;
and antifrag does *not* isolate the issue.


> > Forgive me if I'm starting to be rude, Christoph. This is really
> > irritating.
>
> Sorry but I have had too much exposure to philosophy. Talk about absolutes
> like guarantees (that do not exist even for order 0 allocs) and unlikely
> memory fragmentation scenarios to show that something does not work seems
> to be getting into some metaphysical realm where there is no data anymore
> to draw any firm conclusions.

Some problems can not be solved easily or at all within reasonable
constraints. I have no problems with that. And it is a valid stance to
take on the fragmentation issue, and the hash collision problem, etc.

But what do you say about viable alternatives that do not have to
worry about these "unlikely scenarios", full stop? So, why should we
not use fsblock for higher order page support?

Last times this came up, you dismissed the fsblock approach because it
adds another layer of complexity (even though it is simpler than the
buffer layer it replaces); and also had some other strange objection like
you thought it provides higher order pages or something.

And as far as the problems I bring up with your approach, you say they
shouldn't be likely, don't really matter, can be fixed as we go along, or
want me to show they are a problem in a real world situation!! :P


> Software reliability is inherent probabilistic otherwise we would not have
> things like CRC sums and SHA1 algorithms. Its just a matter of reducing
> the failure rate sufficiently. The failure rate for lower order
> allocations (0-3) seems to have been significantly reduced in 2.6.23
> through lumpy reclaim.
>
> If antifrag measures are not successful (likely for 2M allocs) then other
> methods (like the large page pools that you skipped when reading my post)
> will need to be used.

I didn't skip that. We have large page pools today. How does that give
first class of support to those allocations if you have to have memory
reserves?
