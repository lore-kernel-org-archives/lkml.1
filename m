Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZAKJz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZAKJz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZAKJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:55:50 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:58735 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZAKJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:55:48 -0500
Date: Sun, 11 Jan 2009 10:55:45 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Brad Parker <brad@heeltoe.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: copy_{to,from}_user
In-Reply-To: <20090111020923.GC29153@elte.hu>
Message-ID: <Pine.LNX.4.64.0901111055040.30201@anakin>
References: <4056.1231523557@mini> <1231538061.29452.8.camel@twins>
 <20090111020923.GC29153@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2009-01-09 at 12:52 -0500, Brad Parker wrote:
> > > I have a question about copy_{to,from}_user.  
> > > 
> > > Most implementations I've seen do in-order copies and notice when an
> > > exception occurs and report back the progress.  This is straight
> > > forward.
> > > 
> > > (but to be honest, I have suspicions about how just how accurate those
> > > reports are i.e. +/- 1-3 bytes on some architectures)
> > > 
> > > On some cpu's it is advantageous to do an out-of-order copy to take
> > > advantage of various cache fill mechanisms.
> > > 
> > > The problem is that the out-of-order copy makes it impossible to know
> > > where the exception occurred (in terms of progress).
> > > 
> > > Would it be permissible to have a version of copy_{to,from}_user which
> > > does an out-of-order copy and when an exception occurs, restarts the
> > > copy from the beginning using a simple in-order copy, to make it
> > > possible to identify where the exception occurs?
> > > 
> > > The idea is that exceptions are rare and so the performance hit of doing
> > > the "recopy" would be minimal and would provide the required accuracy.
> > 
> > x86_64 already does some unrolling and is inaccurate as to where exactly
> > it happens. The only thing that is very important is that you _never_
> > say you copied more than you actually did.
> > 
> > That was the source of a data corruption bug a while ago, the code did 
> > something like sequences: read 8 words, write 8 words. And reported the 
> > number of bytes read, instead of bytes written, which is an 
> > over-estimation.
> 
> you sure must have meant 'write 7 words' or something like that?

I understood it as: the code read 8 words, and wrote 8 words.
But only n < 8 words could be written, while the code still returned 8.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
