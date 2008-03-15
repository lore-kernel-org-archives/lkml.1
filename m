Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYCOX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYCOX2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYCOX1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:27:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43520 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbYCOX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:27:53 -0400
Date: Sat, 15 Mar 2008 23:05:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315230558.12e9c96c@the-village.bc.nu>
In-Reply-To: <200803151500.05993.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803151417.13899.phillips@phunq.net>
	<20080315210308.72824eb3@the-village.bc.nu>
	<200803151500.05993.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It makes a lot of difference,
> 
> It makes a difference of degree, not of kind.

I think "I get my data back" is a difference in kind.

> But interpreting a barrier to mean flush through to rotating media...
> performance will drop to the millisecond per transaction zone, like a

That isn't anything to do with what was being proposed. *ORDERING* not
flush to media.

> Even raid controllers... so you agree that some of them just don't
> respond conservatively to tagged commands, either because the engineers
> don't know how to implement that (unlikely) or because they want to win
> the performance benchmarks, and they do trust their battery?

The ones that don't respect tagged ordering are the ultra cheap nasty
things you buy down the local computer store that come with a 2 page
manual in something vaguely like English. The stuff used for real work is
quite different.

> Ramback already is taken seriously, just not by you.  That is fine, you
> apparently do not need or want the speed.

I want the speed and reliability. Without that ramback is a distraction
until someone solves the real problems.

> they need to achieve microsecond level transaction throughput and data

You have no guarantee of commit to stable storage so your use of the word
"transaction" is a bit farcical.

There are a whole variety of ways to get far better results than "whoops
bang there goes the file system". Log structured backing media is one,
even snapshots. That way you'd quantify that for the cost of more
rotating storage (which is cheap) you can only lose "x" minutes of data
and will lose everything from a defined consistent point. File based
backing store also has similar properties done right, but needs some
higher level care to track closure and dirty blocks on a per inode basis.

Alan
