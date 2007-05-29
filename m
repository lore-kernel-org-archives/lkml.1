Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXE2PbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXE2PbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXE2PbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:31:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:64356 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXE2PbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tW3r4k847OP/IqunmZK6Ss3wxs9YMtWeZclZByeEUlYrC4LxS/1As0hhAkwD4oOgaAkaeNheGzJHtux8q1xS/D3OdrIldVTaGfkpXfhAfkMcs3diyQNS8nteDLt6gwhr0OkX21U5L78mhzuuoEMceybGUsUK2tVDlXEMX5v+o7s=
Message-ID: <9a8748490705290831x15a552c1q75f858b5509f2f4c@mail.gmail.com>
Date: Tue, 29 May 2007 17:31:12 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "M Macnair" <mmacnair@gmail.com>
Subject: Re: Seeding /dev/random not working
Cc: "Pavel Machek" <pavel@ucw.cz>, "Theodore Tso" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <de6d2b4f0705290817g2b92f031re29c52ed9f3264a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
	 <20070529131501.GA9899@thunk.org> <20070529141456.GC5840@ucw.cz>
	 <de6d2b4f0705290817g2b92f031re29c52ed9f3264a7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/07, M Macnair <mmacnair@gmail.com> wrote:
> On 5/29/07, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > > > I have two embedded boards (one ARM, one PowerPC), running two
> > > > different versions of 2.6.  They have no hard drives, keyboards or
> > > > mice.  They each have a NIC, but I understand these make no
> > > > contribution to the entropy pool.
> > > >
> > > >     if [ -f $random_seed ]; then
> > > >             cat $random_seed >/dev/urandom  # should seed the pool
> > > >     fi
> > > >     dd if=/dev/urandom of=$random_seed count=1 2>/dev/null # save some
> > > > data from urandom for next boot
> > > >
> > > > I have rebooted my boards many times, and after each boot I read the
> > > > contents of $random_seed.  Whilst it does not happen every time, the
> > > > contents of $random_seed are /often the same/.  To give you a feel:
> > > > rebooted 11 times, got a total of 3 different outputs.
> > >
> > > Ok, so this is telling me a couple of things.  First of all, if you're
> > > only getting three outputs, it means that you don't have any
> > > peripherals feeding entropy into the system from the boot sequence.
> > > Without any hard drives, keyboards or mice, and a NIC whose device
> > > driver hasn't been configured to feed entropy, you're definitely
> > > hosed.
> >
> > Can we get at least time-of-boot from rtc clock to the pool? We really
> > should not be getting identical outputs...
>
> Ah yes that is one thing I forgot to mention - when you turn these
> boards off, you really do turn them off - no battery means no clock.
> They wake up every time in 1970.
>
> I am planning on providing my own entropy to this system by feeding
> /dev/random (which leads to the problem of it not working...).

Depending on how high quality randomness you need, you could just let
your NIC driver provide entropy by changing interrupt handlers to use
SA_SAMPLE_RANDOM.
Sure, getting entropy that way allows an outside attacker to influence
the pool if they can obtain a high degree of control over what data
you recieve and when, but in most realistic scenarios it should be
acceptable (and it's certainly better than no entropy at all).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
