Return-Path: <linux-kernel-owner+w=401wt.eu-S965340AbXA3M5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340AbXA3M5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965341AbXA3M5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:57:32 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:53462 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965340AbXA3M5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:57:31 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 30 Jan 2007 07:56:20 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <45BF3954.8050106@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Nick Piggin wrote:

> Robert P. J. Day wrote:
> >   Add the inline function "is_power_of_2()" to log2.h, where the value
> > zero is *not* considered to be a power of two.
>
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> >  /*
> > + *  Determine whether some value is a power of two, where zero is
> > + * *not* considered a power of two.
> > + */
>
> Why the qualifier? Zero *is* not a power of 2, is it?

no, but it bears repeating since some developers might think it *is*.
if you peruse the current kernel code, you'll find some tests of the
simpler form:

	((n & (n - 1)) == 0))

which is clearly testing for "power of twoness" but which will return
true for a value of zero.  that's wrong, and it's why it's emphasized
in the comment.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
