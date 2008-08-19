Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYHSHok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYHSHok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYHSHo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:44:29 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:42841 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752593AbYHSHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:44:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ndSvs4/xNEg7A3PRjfs0oLY/hnOm4GPK2EaPQMTMna/Ju4K2py19GHdq+2MCJcyHnFdqUjrKyy4pJiS/dbrz7WYXjDf8x/elbU86mIS23lWhPZXnRGqPEzAWjClPCzEw8AtINLNX77J+pRXsIq76ch4IC04GS4EvPxYPH6YIjQk=  ;
X-YMail-OSG: n.k8IjIVM1kTSE10k_6Owc1_mHqnKp35Pnc7GRl1M00DY6dg_o18v0LTJRw1uytcWBzMIe_mpOh9U.7LZBxVXtTidwxZwFbhR6SE5YmglucZ6D9RrrnKjXX938TjnrXf9Y8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
Date: Tue, 19 Aug 2008 17:44:11 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
References: <1218880552.11912.9.camel@matrix> <200808182214.08942.nickpiggin@yahoo.com.au> <48A9B906.7090201@qualcomm.com>
In-Reply-To: <48A9B906.7090201@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191744.11335.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 04:01, Max Krasnyansky wrote:
> Nick Piggin wrote:
> > On Monday 18 August 2008 21:51, Peter Zijlstra wrote:

> > Correctness from the kernel's POV is implementing APIs as advertised,
> > and just as importantly, not changing them. We can argue about how RT
> > apps work, but there is no argument that the kernel has broken
> > backwards compatibility and standards.
>
> Just wanted to mention that I'm with Nick on this one. I pointed this
> (ie POSIX breakage) out as soon as the change went in. I do have a valid
>   (which some people disagree with ;-)) workload that uses 100% of the
> CPU. So my unit-tests caught this right away.

Ouch. Yep, so much for making assumptions about how apps will use the
API.


> Anyway, "RT bandwidth throttling" has been in and enabled be default
> since 2.6.25. So I'm not sure if it makes sense to revert the default at
> this point.
> If we do change the default maybe we can add a CONFIG_ option for this
> so that it can be compiled out completely.

It definitely does. Most serious users deploying real realtime code
will not be close to 2.6.25. If we leave it until they start complaining,
the problem will be much bigger because then we'll have sets of people
that rely on both behaviours.

Please fix this Peter.
