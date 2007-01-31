Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbXAaKsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbXAaKsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932994AbXAaKsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:48:42 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:57954 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbXAaKsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:48:41 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 05:47:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Vegard Nossum <vegard@peltkore.net>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <36577.129.240.220.12.1170238420.squirrel@peltkore.net>
Message-ID: <Pine.LNX.4.64.0701310537040.31696@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
    <45BF3954.8050106@yahoo.com.au>    <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
    <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
 <36577.129.240.220.12.1170238420.squirrel@peltkore.net>
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

On Wed, 31 Jan 2007, Vegard Nossum wrote:

> On Tue, January 30, 2007 3:12 pm, Jan Engelhardt wrote:
> >
> >>> Why the qualifier? Zero *is* not a power of 2, is it?
> >
> > No, it is not:
> >
> > 	In[1]:= Solve[2^n == 0, n]
> >
> > 	Out[1]= {}
> >
> > So says Mathematica5.
>
> As a side note, I would just like to point out that Mathematica does
> not deal with modular arithmetic by default (which programmers very
> much do). In fact, in modular arithmetic, zero IS a power of two.
>
> 2^n = 0 (mod 2^n)
>
> To see if it holds for bytes, substitute n = 8, and you get 2^8 = 0
> (mod 256). In other words: Zero is the eighth power of two modulo
> 256.

that's a bit esoteric but, yes, you make a good point.

> Modular arithmetic is, however, very often a source of errors in
> programming (unchecked-for overflows and underflows), and it is
> questionable whether the programmer would really want 0 reported as
> a power of two.

precisely.   given the definition of "is_power_of_2()" that's been
published, some people will (quite correctly) point out that using
that macro in place of the test "(n & (n - 1))" isn't quite the same
thing.  and they would be correct.

but one wonders how many programmers have been using that very test
"((n & (n - 1))" without realizing that it would accept zero, and that
it has been accepting zero all this time, perhaps leading to weird and
inexplicable errors.

rewriting that test as "is_power_of_2()" may, in fact, cause some
things to suddenly break, but perhaps those are things that should
have been *forced* to break anyway, to identify where the condition
check was incorrect all this time, and someone's just been lucky, or
something like that.

***NOTE***:  and that's why i suggested that the individual
maintainers might want to make this substitution themselves, to make
sure everything continues to work.  because if you leave it as a
project for the kernel janitors, they might not realize what you had
in mind.  so it's in your best interest to start cleaning this up on
your own.

just my $0.02 (Cdn.)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
