Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXHQIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXHQIzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 04:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbXHQIyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 04:54:54 -0400
Received: from mail.suse.de ([195.135.220.2]:44397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbXHQIyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 04:54:53 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Fri, 17 Aug 2007 10:52:37 +0200
User-Agent: KMail/1.9.1
Cc: Paul Mackerras <paulus@samba.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       satyam@infradead.org, clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <18117.4848.695269.72976@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708162033400.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708162033400.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171052.39477.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007 05:42, Linus Torvalds wrote:
> On Fri, 17 Aug 2007, Paul Mackerras wrote:
> > I'm really surprised it's as much as a few K.  I tried it on powerpc
> > and it only saved 40 bytes (10 instructions) for a G5 config.
>
> One of the things that "volatile" generally screws up is a simple
>
> 	volatile int i;
>
> 	i++;

But for atomic_t people use atomic_inc() anyways which does this correctly.
It shouldn't really matter for atomic_t.

I'm worrying a bit that the volatile atomic_t change caused subtle code 
breakage like these delay read loops people here pointed out.
Wouldn't it be safer to just re-add the volatile to atomic_read() 
for 2.6.23? Or alternatively make it asm(), but volatile seems more
proven.

-Andi
