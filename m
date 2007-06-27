Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbXF0FXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbXF0FXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXF0FX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:23:27 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44869 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753686AbXF0FX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:23:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2W2IeXXw/h8N/OH4V5Ninp2kgsaSGtV1uHnRS12xS88WPcyaO1dKbuOx5zT3mYiwCcqnOvPt0yCttmVKzNwc44EYx0OKQ3vOQ6J1LcliQ+ukgIr0/VLiCp0Bh4VutzrlQWvgFK++jmrti782QxkP9jUaTk4KycwprdmwHRm8Pt4=  ;
X-YMail-OSG: BwrXmM0VM1ksyJ6DDk3KqoH_8RQup8Zv7IloJCjaS7C1Nxd1l3SfUzzrqI4DXM8QEQ7.SyBq3Q--
Message-ID: <4681F448.3040201@yahoo.com.au>
Date: Wed, 27 Jun 2007 15:23:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 26 Jun 2007, Nick Piggin wrote:
> 
>>Hmm, not that I have a strong opinion one way or the other, but I
>>don't know that they would encourage bad code. They are not going to
>>reduce latency under a locked section, but will improve determinism
>>in the contended case.
> 
> 
> xadd really generally *is* slower than an add. One is often microcoded, 
> the other is not.

Oh. I found xadd to be not hugely slower on my P4, but it was a little
bit.


> But the real problem is that your "unlock" sequence is now about two 
> orders of magnitude slower than it used to be. So it used to be that a 
> spinlocked sequence only had a single synchronization point, now it has 
> two. *That* is really bad, and I guarantee that it makes your spinlocks 
> effectively twice as slow for the non-contended parts.

I don't know why my unlock sequence should be that much slower? Unlocked
mov vs unlocked add? Definitely in dumb micro-benchmark testing it wasn't
twice as slow (IIRC).


> But your xadd thing might be worth looking at, just to see how expensive 
> it is. As an _alternative_ to spinlocks, it's certainly viable.
> 
> (Side note: why make it a word? Word operations are slower on many x86 
> implementations, because they add yet another prefix. You only need a 
> byte)

No real reason I guess. I'll change it.

-- 
SUSE Labs, Novell Inc.
