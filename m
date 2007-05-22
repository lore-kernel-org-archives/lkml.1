Return-Path: <linux-kernel-owner+w=401wt.eu-S935021AbXEVRUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbXEVRUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934713AbXEVRUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:20:23 -0400
Received: from [216.16.235.2] ([216.16.235.2]:32791 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760265AbXEVRUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:20:21 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 13:18:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <a781481a0705221004t4058154akb8b142dfdd2d6073@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705221309550.16873@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> 
 <20070522135927.GA2098@stusta.de>  <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
  <20070522161951.GC2098@stusta.de> <a781481a0705221004t4058154akb8b142dfdd2d6073@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Satyam Sharma wrote:

> On 5/22/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Tue, May 22, 2007 at 10:04:16AM -0400, Robert P. J. Day wrote:
...
> > > no, i think you're thinking of the alternative ATTRIB_NORET
> > > macro. as you can read in my previous post, NORET_TYPE used to
> > > resolve to "__volatile__" for very old gcc.  so i think it's
> > > legitimately dead and can be ripped out.
> >
> > No doubt that it could be removed because it doesn't have any
> > effect.
> >
> > But locking at the usages, it seems to have been used when people
> > thought it was what __noreturn now is, so replacing NORET_TYPE
> > with __noreturn might be a small optimization (but every
> > NORET_TYPE should be checked that it's actually correct).
>
> Adrian's right, and in fact from ...
>
> http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html
>
> ... we know why that macro existed and evaluated to __volatile__ for
> pre-2.5 gcc. Perhaps most of today's users of NORET_TYPE were
> probably looking for ATTRIB_NORET (which is quite common) actually.
>
> [ __noreturn is defined in compiler-gcc.h, so the easier way would
> be to kill NORET_TYPE and replace its usages with ATTRIB_NORET
> instead. Of course, after verifying that the function _really_ never
> returns. ]

oh, barf.  why does this always happen to me? :-)  i just verified
that a patch i threw together to rid the tree of NORET_TYPE does in
fact (and not surprisingly) produce *exactly* the same 7000+ lines of
output and, based on what we've established so far, that's exactly
what it should have done.

at this point, i'd prefer to submit that patch as is for a couple
reasons.  first, it's a no-brainer if all it does is remove every
reference to NORET_TYPE and leave everything else untouched.  if i go
beyond that, then i'm starting to make judgment calls and possibly
changing the logic, which makes this a totally different cleanup job.

also, in a number of cases, there are some routines that are qualified
with *both* NORET_TYPE and ATTRIB_NORET, suggesting that some
developers knew very well what the difference was, and i was going to
deal with all that ATTRIB_NORET nonsense in another pass.

in short, i'd rather keep this as an aesthetic, no-op kind of cleanup,
otherwise, i just *know* things are going to get ugly.  the final
patch will follow shortly.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
