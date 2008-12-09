Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYLIKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYLIKOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYLIKOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:14:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47693 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbYLIKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:14:00 -0500
Date: Tue, 9 Dec 2008 10:13:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081209101332.2b81601b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081209010937.GL2501@mit.edu>
References: <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	<ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	<20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	<ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	<20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
	<ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
	<20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
	<ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
	<20081208011850.GA10289@mit.edu>
	<ac3eb2510812071935v7e1b8c75x4d8fa9ce1c8dba6@mail.gmail.com>
	<20081209010937.GL2501@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> apparently not triggering, since it could be that Debian's initrd
> might cause some other uncaught recursion loop if we don't drive this
> problem determination to root cause.

Agreed - and there are all sorts of obscure and wonderful other ways to
trip this up which need the detector (AF_UNIX modular and doing a syslog
for example).

> > That's why I still think it's a good thing, to connect the core tty
> > devices to their dev_t handler internally, before we init all the
> > other drivers and run userspace.
> 
> Um, how early?  (/me searches lkml.org for the original patch).  Ah,
> OK, you want to do it postcore....  There may actually be a problem
> with that, because it looks like vtconsole_class_init (which is
> currently run as a postcore initcall) really wants to happen before
> the tty layer initializes itself.  So moving tty into postcore could
> potentially run into problems, depending on whether vt.c's or
> tty_io.c's initcalls are run first.

Its playing with fire and doing so to paper over a completely different
problem. The recursion detector is generic and should be sufficient. If
it isn't then it needs improving to be generic, sufficient and working.
