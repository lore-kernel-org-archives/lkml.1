Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbXCEUTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbXCEUTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXCEUTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:19:00 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:24379 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbXCEUS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:18:59 -0500
Message-ID: <45EC7B2F.4040400@tls.msk.ru>
Date: Mon, 05 Mar 2007 23:18:55 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Thunderbird 1.5.0.5 (X11/20060813)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (trivia) remove useless typecast around `jif' variable
References: <20070305161251.AE2C97FAA@paltus.tls.msk.ru> <Pine.LNX.4.61.0703051724520.24366@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703051724520.24366@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Mar 5 2007 19:12, Michael Tokarev wrote:
> 
>> Date: Mon,  5 Mar 2007 19:12:51 +0300 (MSK)
>> From: Michael Tokarev <mjt@tls.msk.ru>
>> To: undisclosed-recipients:  ;
> 
> I have no clue what you sent it to, so I added linux-kernel again.

Oops.. I forgot to add the To: header (it was only sent to lkml).
][
> In case we wanted to use different types, we would also have to
> change the accompanying %lu into %llu. Only changing jif to u64 will
> cause a problem, as the compiler does _not_ automatically
> promote/demote types in varargs that already have a certain size. In
> other words,

Sure thing, the change will be needed.  But the thing is - with the
cast in place, compiler will be completely silent, while w/o the cast
it will produce a warning (or at least it's able to).

Generally, casts are bad, that's the point.  Especially redundrand
ones like here.

As a side note, I dislike when people remove casts from functions
returning void*.  For example,

  struct somestruct *foo;

  foo = (struct somestruct *)kmalloc(sizeof(struct somestruct));

With the cast in place, the compiler will warn if somestruct will
be changed to something else, but without the cast, the compiler
will happily accept the (now wrong) line.

[]
> will throw a warning (rightfully if you ask me).

Yes, that's what i was referring to when said "let the compiler
do some work for us".

/mjt
