Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbXBXCRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbXBXCRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 21:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933345AbXBXCRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 21:17:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:55044 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344AbXBXCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 21:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=to2H0dZdRmCgzPGNV9EQYEwHRx9q1bNfqW0aQ+z7nqy4ALlAkON3N5wWBsqgV2tEyYggwXS1dXohFPHnSt1yJwKOTKoyc176K1treGlwGH0pCLQV5AX710z6DkB7Z+JbCSwepTV8RtM2Bto9muTpqMkvxvKw7OT2rw3eanHGzfQ=
Message-ID: <f2b55d220702231817q2a2d0d7egcecfd1b370640b35@mail.gmail.com>
Date: Fri, 23 Feb 2007 18:17:12 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <f2b55d220702231651u2c1915b1we04de7ae41393874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
	 <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
	 <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
	 <f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
	 <20070224010824.5cf6c0ac@lxorguk.ukuu.org.uk>
	 <f2b55d220702231651u2c1915b1we04de7ae41393874@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> (On a pre-EABI ARM, there is even a substantial
> cache-related penalty for encoding the syscall number in the syscall
> opcode, because you have to peek back at the text segment to see it,
> which costs you a D-cache stall.)

Before you say it, I'm aware that this is not directly relevant to TLS
switch costs, except insofar as the "arch-dependent syscalls"
introduced for certain parts of ARM TLS handling carry the same
overhead as any other syscall.  My point is that the system impact of
seemingly benign operations is not always predictable even to the arch
experts, and therefore one should be "parsimonious" (to use Kahan's
word) in defining what semantics programmers may rely on in
performance-critical situations.

If you arrange things so that threadlets are scheduled as much as
possible in bursts that share the same processor context (process
context, location in program text, TLS arena, FPU state -- basically
everything other than stack and integer registers), you are giving
yourself and future designers the maximum opportunity for exploiting
hardware optimizations.  This would be a good thing if you want
threadlets to be performance-competitive with state machine designs.

If you still allow application programmers to _use_ shared processor
state, in the knowledge that it will be clobbered on threadlet switch,
then threadlets can use most of the coding style with which
programmers of event-driven frameworks are familiar.  This would be a
good thing if you want threadlets to get wider use than the innards of
three or four databases and web servers.

Cheers,
- Michael
