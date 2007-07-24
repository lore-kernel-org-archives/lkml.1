Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbXGXKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbXGXKcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbXGXKcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 06:32:09 -0400
Received: from web53810.mail.re2.yahoo.com ([206.190.36.205]:42114 "HELO
	web53810.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758008AbXGXKcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 06:32:08 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 06:32:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dKzl5ufWzUHydHoUfytXU0KqI+kUaWr1B+f4N3rPhfriFk5OcOr+vLVsHkYKKEcW53MALlUhai0h0vPbx6xDw1DtEvESjKgRP7XU5oAASdqLgZ+lgSNWGoCl0jykkiaUhqMpV5fVkJrkV0yx4pmk4/2UdkW5px8utLjwF7juKqI=;
X-YMail-OSG: zp8MCEgVM1k0hPLbFKw1G424_EpfBjxrggG1FknmGvv6ojOD66CG6JeFvWyllH5Rn4ADIRoUgVIveY5YqM8OGSK6WMJXvQ.Q8rnMWyXfdEzo5q1nqoOJBRMdMHinnw--
Date: Tue, 24 Jul 2007 20:25:26 +1000 (EST)
From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241359470.1433@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <423904.37199.qm@web53810.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:

> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 
> > Satyam Sharma wrote:

> > > Consider this (the above two functions exist
> only for clear_bit(),
> > > the atomic variant, as you already know), the
> _only_ memory reference
> > > we care about is that of the address of the
> passed bit-string:
> > 
> > No. Memory barriers explicitly extend to all
> memory references.
> 
> [ Compiler barrier, you mean, that's not true of CPU
> barriers. ]

For the purpose of this discussion (Linux memory
barrier semantics, on WB memory), it is true of CPU
and compiler barriers.

 
> In any case, I know that, obviously. I asked "why"
> not "what" :-) i.e.
> why should we care about other addresses / why do we
> want to extend
> the compiler barrier to all memory references -- but
> Jeremy seems to
> have answered that ...

Obviously because we want some kind of ordering
guarantee at a given point. All the CPU barriers
in the world are useless if the compiler can reorder
access over them.


> > Repeating what has been said before: A CPU memory
> barrier is not a
> > compiler barrier or vice versa. Seeing as we are
> talking about
> > the compiler barrier, it is irrelevant as to
> whether or not the
> > assembly includes a CPU barrier.
> 
> I think it is quite relevant, in fact. From
> Documentation/atomic_ops.txt,
> smp_mb__{before,after}_clear_bit(), as the name
> itself suggests, must
> be _CPU barriers_ for those arch's that don't have
> an implicit
> _CPU barrier_ in the clear_bit() itself [ which i386
> does have already ].
> 
> As for a compiler barrier, the asm there already
> guarantees the compiler
> will not optimize references to _that_ address

One or both of us still fails to understand the other.

bit_spin_lock(LOCK_NR, &word);
var++;
/* this is bit_spin_unlock(LOCK_NR, &word); */
smp_mb__before_clear_bit();
clear_bit(LOCK_NR, &word);

Are you saying that it is OK for the store to var to
be reordered below the clear_bit? If not, what are you
saying?



      Yahoo!7 Mail has just got even bigger and better with unlimited storage on all webmail accounts.
http://au.docs.yahoo.com/mail/unlimitedstorage.html



