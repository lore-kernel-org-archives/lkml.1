Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbXFXXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbXFXXN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:13:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11998 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:13:49 -0400
Date: Mon, 25 Jun 2007 01:13:47 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070624231347.GC21724@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
	linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <20070624224411.GB21724@alinoe.com> <9a8748490706241548r5a2bab5fw20daf424beb338d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490706241548r5a2bab5fw20daf424beb338d0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:48:45AM +0200, Jesper Juhl wrote:
> Did you try resending it?
> Sometimes patches get missed, overlooked, dropped on the floor by mistake 
> etc.
...
> When it comes to getting patches into mainline, asking twice (or more)
> is sometimes required, and it's considered your responsability as
> submitter to resend a patch if noone reacts to it the first time
> around.

Some history:

At the time I suffered from a severe RSI (Repitive Stress Injury) and
I had to take into account that I'd not be able to type anymore at
some point.  This is why I became interested in speech recognition,
even though I had to limit my typing time to 2 hours or so per day.
The only speech recognition software available for linux was 'ViaVoice',
a discontinued package sold by IBM. I managed to get my hand on one
(even though they aren't even sold anymore *cough cough*) and quickly
found out that it was so old that it didn't even run anymore. I hacked
the binary package (closed source and stuff) until it ran again (which
involved writing this kernel patch). However, then I found out that
ViaVoice was unusable for me: it didn't recognize my voice - it just
didn't work (it worked for others, so it much be my voice or accent
or whatever). Hence, I dropped the whole project. I could use my
two hours per day of typing better.

Now - about the resending the patch... I usually do, but I also
reschedule the priority of such a task. In this case, since I NEVER
do anything with recording - and the project that made me be involved
was dead as far as me was concerned - it got scheduled so far at
the bottom that I simply never got to it anymore.

I have no idea how much the code has changed in the meantime, but
the problem is/was this:

There is significant difference between ALSA and OSS such that an
application that works under OSS does not work anymore with the
OSS emulation under ALSA.

Firstly, the total recording buffer that you get is limited - while
that is not the case with OSS. Secondly, if that buffer runs full
(xrun) the stream is stopped permanently and not restarted, while
it is restarted with OSS.

You can download testcode.c from
http://www.xs4all.nl/~carlo17/alsa/index.html
and run it:

hikaru:~>./a.out
    Allocated 2 buffers of 1024 bytes.
    Allocated 2 buffers of 2048 bytes.
    Allocated 2 buffers of 4096 bytes.
    Successfully allocated a buffer that is large enough.
    Available bytes: 3072
    Available bytes: 4768
    Available bytes: 6432
    Available bytes: 8192
    Successfully caused an xrun.
    non-blocking fragments: 2
    non-blocking bytes: 8192
    Available bytes in buffer: 9856
    Additionally read 1024 bytes.
    Additionally read 1024 bytes.
    Additionally read 1024 bytes.
    Additionally read 1024 bytes.
    Additionally read 1024 bytes.
    Additionally read 1024 bytes.
    Stream is not restarted after xrun.

Since this is not the same behaviour as with OSS - I think it's a bug.

I don't know if the patch on that patch can still be applied,
but if not - then I'm sure you are more into that code than
me and it will be a lot easier for you to fix this the right
way in the correct kernel code :)

-- 
Carlo Wood <carlo@alinoe.com>
