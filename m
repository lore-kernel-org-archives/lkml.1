Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYDGJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYDGJiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYDGJh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:37:57 -0400
Received: from mail.fuw.edu.pl ([193.0.80.14]:50733 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYDGJh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:37:56 -0400
X-Greylist: delayed 3411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2008 05:37:55 EDT
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: suspend issue
Date: Mon, 7 Apr 2008 10:41:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pavel Machek" <pavel@ucw.cz>, "Soeren Sonnenburg" <kernel@nn7.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com> <20080406232849.GA789@elf.ucw.cz> <dd18b0c30804061708h3fcf27b2t7411ff4f2244a48b@mail.gmail.com>
In-Reply-To: <dd18b0c30804061708h3fcf27b2t7411ff4f2244a48b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071041.11899.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, Justin Mattock wrote:
> Hello; I don't know how to do a git bisect(too much of a noob)
> regards;

First, please don't top post.  Looking at this message you can see why it
really doesn't make sense. :-)

Now, in short, to run a git bisection:

(1) clone the Linus' tree (see http://linux.yyz.us/git-howto.html#download_first_time)
(2) from within the kernel source code directory downloaded in (1) run
	$ git bisect start
	$ git bisect bad
    (this will mark the last revision as a failing one)
(3) If you have already verified that 2.6.24 works correctly, run
	$ git bisect good v2.6.24
    (this will mark the 2.6.24 kernel as a good one)
(4) as a result of this, git will select a kernel revision between 2.6.24 and
    the most recent one for testing.  Compile it, install it and check if it
    works.  If it does, run
	$ git bisect good
    Otherwise, run
	$ git bisect bad
(5) repeat (4) until there's no more revisions to test.

If you encounter any problems, please ask what to do next.

Thanks,
Rafael


> On Sun, Apr 6, 2008 at 11:28 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
> >  > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
> >  > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
> >  > > I recompile the kernel and had forgotten to compile fglrx, when
> >  > > performing a suspend without fglrx I was confronted with the dreaded
> >  > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
> >  > > and to my amazement suspend reacted properly again.
> >  >
> >  > Yeah, but I it does not even work without X - console only!
> >  >
> >  > s2ram -f -p used to work since at least 2.6.20 ... and is now not
> >  > anymore in 2.6.25-*
> >
> >  Can you do git bisect?
> >                                                                         Pavel
> >  --
> >  (english) http://www.livejournal.com/~pavelmachek
> >  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> >
> 
> 
> 



-- 
Rafael J. Wysocki, Ph.D.
Institute of Theoretical Physics
Faculty of Physics of Warsaw University
ul. Hoza 69, 00-681 Warsaw
[tel: +48 22 55 32 263]
[mob: +48 60 50 53 693]
----------------------------
One should not increase, beyond what is necessary,
the number of entities required to explain anything.
			-- William of Ockham
