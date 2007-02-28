Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbXB1VqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbXB1VqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXB1VqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:46:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4903 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbXB1VqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:46:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 13:46:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070228212306.GA27127@elte.hu>
Message-ID: <Pine.LNX.4.64.0702281338510.6806@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <20070228202156.GA15846@elte.hu> <Pine.LNX.4.64.0702281259430.6806@alien.or.mcafeemobile.com>
 <20070228212306.GA27127@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Ingo Molnar wrote:

> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Did you hide all the complexity of the userspace atom decoding inside 
> > another function? :)
> 
> no, i made the 64-bit and 32-bit structures layout-compatible. This 
> makes the 32-bit structure as large as the 64-bit ones, but that's not a 
> big issue, compared to the simplifications it brings.

Do you have a new version to review?



> > > But i'm happy to change the syslet API in any sane way, and did so 
> > > based on feedback from Jens who is actually using them.
> > 
> > Wouldn't you agree on a simple/parallel execution engine [...]
> 
> the thing is, there's almost zero overhead from having those basic 
> things like conditions and the ->next link, and they make it so much 
> more capable. As usual my biggest problem is that you are not trying to 
> use syslets at all - you are only trying to get rid of them ;-) My 
> purpose with syslets is to enable a syslet to do almost anything that 
> user-space could do too, as simply as possible. Syslets could even 
> allocate user-space memory and then use it (i dont think we actually 
> want to do that though). That doesnt mean arbitrary complex code 
> /should/ be done via syslets, or that it wont be significantly slower 
> than what user-space can do, but i'd not like to artificially dumb the 
> engine down. I'm totally willing to simplify/shrink the vectoring of 
> arguments and just about anything else, but your proposals so far (such 
> as your return-value-embedded-in-atom suggestion) all kill important 
> aspects of the engine.

Ok, we're past the error code in the atom, as Linus pointed out ;)
How about this, with async_wait returning asynid's back to a userspace 
ring buffer?

struct syslet_utaom {
        long *result;
        unsigned long asynid;
        unsigned long nr_sysc;
        unsigned long params[8];
};

My problem with the syslets in their current form is, do we have a real 
use for them that justify the extra complexity inside the kernel? Or with 
a simple/parellel async submission, coupled with threadlets, we can cover 
a pretty broad range of real life use cases?



- Davide


