Return-Path: <linux-kernel-owner+w=401wt.eu-S935853AbXGXKAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935853AbXGXKAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 06:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbXGXKAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 06:00:38 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:33344 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765384AbXGXKAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 06:00:37 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 15:32:02 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: David Howells <dhowells@redhat.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <19305.1185270274@redhat.com>
Message-ID: <Pine.LNX.4.64.0707241526110.1433@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <19305.1185270274@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 24 Jul 2007, David Howells wrote:

> Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:
> 
> > OTOH, as per Linus' review it seems we can drop the "memory" clobber
> > and specify the output operand for the extended asm as "+m". But I
> > must admit I didn't quite understand that at all.
> 
> As I understand it, the "+m" indicates to the compiler a restriction on the
> ordering of things that access that particular memory location, whereas a
> "memory" indicates a restriction on the orderings of all accesses to memory -
> precisely what you need to produce a lock.

Ok, thanks -- I didn't know gcc's behaviour w.r.t. "+m" at all, but in my
defense I'd add all this was quite poorly/wrongly documented in the docs.

> There are a number of things that use test_and_set_bit() and co to implement a
> lock or other synchronisation.  This means that they must exhibit LOCK-class
> barrier effects or better.  LOCK-class barrier effects mean, more or less,
> that all memory accesses issued before the lock must happen before all memory
> accesses issued after the lock.  But it most happen at both CPU-level and
> compiler-level.  The "memory" constraint instructs the compiler in this
> regard.

Yes, thanks for laying this out so clearly, again. So combined with what
you explained above, I think I now fully understand why most of this
series was incorrect ...

> Remember also that this is gcc black magic and so some of it has had to be
> worked out empirically - possibly after sacrificing a goat under a full moon.

:-)


Satyam
