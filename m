Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXGFRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXGFRZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbXGFRZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:25:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50843 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615AbXGFRZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:25:34 -0400
Date: Fri, 6 Jul 2007 13:25:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
Message-ID: <20070706172513.GD10670@c2.user-mode-linux.org>
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468DD6A5.4020705@goop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 10:44:05PM -0700, Jeremy Fitzhardinge wrote:
> Dan Kegel wrote:
> >It'd be nice to see if Valgrind could catch uninitialized
> >references in the kernel, if only to see if Coverity is
> >missing anything that happens in practice.
> >
> >Back in December 2002, Valgrind started to run UML:
> >http://user-mode-linux.sourceforge.net/diary.html
> >http://marc.info/?l=linux-kernel&m=104035199923121&w=2
> >but it wasn't quite usable, and it seems broken since then.
> >The last note I could find about this was from Jeff In July 2005:
> >http://marc.info/?l=linux-kernel&m=112273702329952&w=2

I've checked since 2005, and valgrind was still horribly broken wrt UML.

> Not that I know of.  I think all the pieces are in place now.  The 
> original problem was that Valgrind didn't deal with clone and didn't 
> have accurate signal support.  I fixed that.  Then the problem was 
> dealing with the densely packed small kernel stacks.  Valgrind now has a 
> way of registering stack regions, so that it can distinguish between a 
> stack switch and a normal function call.
> 
> So, I think all it needs now is to scatter some valgrind client requests 
> around the kernel and give it a spin.  See, simple ;)

Don't think so.  With what I get on FC5 (valgrind-3.1.0), I get this:

==31913== Jump to the invalid address stated on the next line
==31913==    at 0x9: ???
==31913==    by 0xBEC1599A: ???
==31913==    by 0x696C2F69: ???
==31913==  Address 0x9 is not stack'd, malloc'd or (recently) free'd
==31913== 
==31913== Process terminating with default action of signal 11 (SIGSEGV): dumping core

UML is cloning a thread in order to test the host's ptrace.  However,
it looks like valgrind is branching to 0x9 for some reason.

This particular bit is going to be problematic for other reasons, but
if valgrind ever looks like it has a chance of working, I can work
around that in UML.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
