Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYFJTUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYFJTUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFJTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:20:28 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:42016 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751955AbYFJTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:20:27 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 10 Jun 2008 12:19:34 -0700
User-Agent: KMail/1.9.9
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <1213121426.8536.7.camel@localhost.localdomain> <adaskvl3yb0.fsf@cisco.com>
In-Reply-To: <adaskvl3yb0.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101219.34995.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 12:05 pm Roland Dreier wrote:
>  > me too.  That's the whole basis for readX_relaxed() and its cohorts: we
>  > make our weirdest machines (like altix) conform to the x86 norm.  Then
>  > where it really kills us we introduce additional semantics to selected
>  > drivers that enable us to recover I/O speed on the abnormal platforms.
>
> Except as I pointed out before, Altix doesn't conform to the norm and
> many (most?) drivers are missing mmiowb()s that are needed for Altix.
> Just no one has plugged most devices into an Altix (or haven't stressed
> the driver in a way that exposes problems of IO ordering between CPUs).
>
> It would be a great thing to use the powerpc trick of setting a flag
> that is tested by spin_unlock()/mutex_unlock() and automatically doing
> the mmiowb() if needed, and then killing off mmiowb() entirely.

Yeah I think that's what Nick's guidelines would guarantee.  And Jes is 
already working on the spin_unlock change you mentioned, so mmiowb() should 
be history soon (in name only, assuming Nick also introduces the I/O barriers 
he talked about for ordering the looser accessors it would still be there but 
would be called io_wmb or something).

Jesse

