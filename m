Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZB0O3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZB0O3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZB0O3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:29:23 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:60604 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZB0O3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:29:22 -0500
Date: Fri, 27 Feb 2009 15:28:04 +0100 (CET)
From: Cedric Roux <sed@free.fr>
To: linux-kernel@vger.kernel.org
Message-ID: <20354297.220251235744884040.JavaMail.root@spooler2-g27.priv.proxad.net>
Subject: /dev/vcs or /dev/tty local colormap retrieving
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.20.243.41]
X-Mailer: Zimbra 5.0.11_GA_2627.UBUNTU8 (ZimbraWebClient - FF2.0 (Win)/5.0.11_GA_2627.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux kernel hackers,

I have a problem.
I want to retrieve the current colormap of a given tty.

/dev/vcsX (or /dev/vcsaX) don't dump the colormap
of the given tty through their read() interface.

The GIO_CMAP ioctl call only returns the current *default*
colormap, which is not what I want, since someone may
send terminal commands to modify the colormap of a
specific tty.

(I am working with EGA/VGA text virtual terminals,
source code in drivers/char/vt.c)

I will do my own private hack to dump the colormap,
but maybe it might be useful for other people as
well, so I send you an email to know if you
are interested.

If yes, what is the prefered way (according to
your internal design policy) to do that?

I think about several methods:
1 - dump the 48 bytes of the colormap at the
    end of read(/dev/vcsaX), so after the screen
    content. Obviously, userland programs that
    don't take into account the dimensions of
    the console may behave strangely after this
    modification, but it's the simplest IMHO,
2 - create a new /dev/vcspX device. Some minor
    number after 191 are still available for
    major 7 c mode. It would pollute /dev,
    but why not,
3 - have a new ioctl, preferably on /dev/vcsaX
    or /dev/vcsX, but might also be available
    for /dev/ttyX (/dev/vcsaX seems more
    natural, because this device already exports
    attributes of characters).

We might also want a write access, why not?
And maybe also get the cursor shape (I didn't
check for that because I don't need it, so it
might already be done somewhere).

If you think this feature is useful, I will
send a patch in a few days.

So, well, that's it.
If it appears that I didn't read the sources
carefully enough and if the feature I want
is already there, I apologize. In which case,
please direct me to the correct source file.

Take care and happy hacking,
Cédric.
