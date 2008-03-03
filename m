Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbYCCRes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbYCCRes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbYCCRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:17:11 -0500
Received: from n16.bullet.mail.mud.yahoo.com ([68.142.201.239]:34259 "HELO
	n16.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759568AbYCCRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:17:09 -0500
X-Yahoo-Newman-Id: 996709.38275.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=X9YX+85D7outglwH4jMTRiZHvU9wVN6494Bwr19bSArJccPqkWot8NyDEws3HBjKMjkdiW6o6vA8x5HdtirMXn44CDJDDLtH0HpcC7cTiqm5llmav6p2R9lztZEvtzs2J99OjMNlQvkN4VjA+byRphtbvrhzld0Q+hKH8pwq93U=  ;
X-YMail-OSG: ZypvM8IVM1m5hVYcvbD0k08Z6s0FmPGG6.Pj_RLT77aTFRE6GhzSU3cs62.B5b7bRD._jz1hRw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Date: Tue, 4 Mar 2008 04:16:33 +1100
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20080303120842.GA28369@elf.ucw.cz> <Pine.LNX.4.44L0.0803031023550.3611-100000@iolanthe.rowland.org> <20080303155330.39e45ad4@core>
In-Reply-To: <20080303155330.39e45ad4@core>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803040416.33937.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 02:53, Alan Cox wrote:
> > Atomicity of reads of write for pointers and integral types (other than
> > long long) should be documented.
>
> NAK.
>
> Atomicity of reads or writes for pointers and integral types is NOT
> guaranteed. Gcc doesn't believe in your guarantee.

Are you sure gcc doesn't? Or is it just "C"?

Linux wouldn't work today if gcc did something non-atomic there
(presuming you're talking about naturally aligned pointers/ints).
It is widely used and accepted.

RCU users are far from the only places to rely on this, although
I guess they are the main ones when it comes to assigning pointers
atomically.

