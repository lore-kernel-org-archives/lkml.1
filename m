Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZAWPNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZAWPNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZAWPNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:13:24 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:39483 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751185AbZAWPNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:13:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YwOvQpjeaoKh41EFjKbrbIh5f4bN0+hxnRvSucATCh9P99JNXEM4F8nZr1PlDIa5noI5RJ2NaE+z1LckZoElVZmknPxT13z6J1Uutk1Eu+ohn1EAhddy3+ms+mYHZ4h2zVaHYCkXcrKElOUcSqSLDPUfQfpaPqJaCOmBCO0HRb4=  ;
X-YMail-OSG: 0mebBZEVM1lVEFKsl6e_q2BQ9O0nqgrOfusAcPDuh6NSas562oLbrNBqsgZzes7Yr6Fog0Irg7elNZnu7WrUX.IsUFWtaYmrRrGKPUIjUpsH5YuNlWPC5jxlarWIOL2WSGnjGYb7sYNJiXDj8aICzWWRVf.6S2I_dfYobXxH4VTZW6S_bcBS.aEwvBHyQQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Sat, 24 Jan 2009 02:12:57 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901231952.53961.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901230955470.13690@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901230955470.13690@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240212.58829.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:03:22 Christoph Lameter wrote:
> On Fri, 23 Jan 2009, Nick Piggin wrote:
> > Hmm, it lists quite a number of advantages that I guess are being
> > reverted too? What was the test case(s) that prompted this commit
> > in the first place? Better ensure it doesn't slow down...
>
> The advantage was mainly memory savings and abilty to redefined kmallocs
> to go directly to the page allocator. Totally avoids slab allocator
> overhead.

Well it sounds in the changelog like a massive performance advantage.
Unfortunately it doesn't really say what the workload was.


> I thought higher order allocations were not supposed to be used in
> performance critical paths?

? You use them all the time in SLUB alone.


> Didnt you want to do everything with order-0
> allocs?

People don't always do what I think is best, unfortunately ;)


> It seems that we currently need the slab allocators to compensate for the
> performance problems in the page allocator for these higher order allocs.
> I'd rather have the page allocator fixed but things are as they are.

No objections from me with speeding up the page allocator of course.


