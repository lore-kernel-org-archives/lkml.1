Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbXHTCtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbXHTCtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXHTCtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:49:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57569 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbXHTCtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:49:06 -0400
Date: Mon, 20 Aug 2007 08:31:47 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David Brownell <david-b@pacbell.net>
cc: Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
In-Reply-To: <200708191757.56520.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.999.0708200806380.2774@enigma.security.iitk.ac.in>
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191719.48340.david-b@pacbell.net>
 <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
 <200708191757.56520.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-46304640-1187578911=:2774"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-46304640-1187578911=:2774
Content-Type: TEXT/PLAIN; charset=us-ascii
Content-Transfer-Encoding: 8BIT



On Sun, 19 Aug 2007, David Brownell wrote:

> On Sunday 19 August 2007, Anton Altaparmakov wrote:
> > >
> > > ISTR we don't *have* a uintptr_t on all architectures, or that would
> > > be the appropriate thing to use in these 32/64 bit ABI scenarios.
> > >
> > >
> > >> Use unsigned long or uintptr_t instead.
> > >
> > > I suspect you mean "unsigned long long"...
> > 
> > No he doesn't.  "unsigned long" is guaranteed to be large enough to  
> > hold a pointer (at least on Linux anyway).

Yup, sizeof(long) >= sizeof(void *) should always be true in Linux C.
I bet a lot of code out there depends on this.

BTW, just curious to know, but which (if any) are the platforms that have
sizeof(long) > sizeof(void *)? [i.e. greater-than but not equal?]

The reason I ask is that gcc will also complain (understandably so) with
"warning: cast from pointer to integer of different size" i.e. even if
it's a conversion from smaller size to greater size, and not really a
case of truncation. Therefore, I wonder if the stricter assertion:
sizeof(long) == sizeof(void *) holds true for Linux C, actually.


> And yet when I used that, I got compiler warnings on some systems.
> 
> ISTR that was the first solution I tried, but GCC really wanted to
> issue warnings.  Either about casting 64-bit to pointer, or about
> casting it to "unsigned long", either way lost precision.

Hmm, if you could fish out those testcases ...


> > On a 32-bit arch "unsigned long" is 32-bit and pointers are 32-bit.
> > 
> > On a 64-bit archi "unsigned long" is 64-bit and pointers are 64-bit.
> 
> So with 32 bit userspace "unsigned long long" is the type to use
> when talking to a 64-bit kernel; and with pure 64-bit code, it's
> enough to write "unsigned long".
> 
> I'm fairly sure that's the root cause of the pain I recall here;
> but I'd have to run experiments again to verify that.  

I suspect the root cause of the pain was that you used "int" or "long"
to talk between kernel and userspace in the first place. You shouldn't,
we have __u32 / __u64 / etc for that.


Satyam
--464262402-46304640-1187578911=:2774--
