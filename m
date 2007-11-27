Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXK0EAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXK0EAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXK0EAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:00:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54446 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbXK0EAY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:00:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: kernel coder <lhrkernelcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: profile code added to netif_receive_skb function
In-Reply-To: Your message of "Sun, 25 Nov 2007 21:46:26 PST."
             <f69849430711252146q3046d3e1n48c377a18e4e4dfb@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <f69849430711252146q3046d3e1n48c377a18e4e4dfb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196136023_2838P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Nov 2007 23:00:23 -0500
Message-ID: <21348.1196136023@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196136023_2838P
Content-Type: text/plain; charset=us-ascii

On Sun, 25 Nov 2007 21:46:26 PST, kernel coder said:
> hi,
> 
> I have added some code to netif_receive_skb function.As linux kernel
> is multhreaded , so there is no gaurantee than mine code is completely
> executed without being disturbed by any other process .Timer interrupt
> handler is an example of code which might interrupt execution of mine
> code.

The trick is to write your code so it doesn't *matter* if other code runs.

For example - the timer interrupt almost certainly doesn't look at or modify
any of *your* code's variables.  So 98% of the kernel's code you don't
even have to *care* if it runs (as long as you aren't doing something
real-time or has similar response-time or throughput constraints).

And if you are worried about that other 2%, where related code, for example the
IRQ handler for a network interface, may have to look at and/or modify some of
your variables, that's when you should be using appropriate locking - there's
mutexes, semaphores, the whole RCU family, and more - none of which I'll
attempt to explain, because I'm not all that good at that stuff.

Basic rule of thumb - if you have something that will break if two things
access it at the same time, put a lock around it, so they take turns.

--==_Exmh_1196136023_2838P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS5ZXcC3lWbTT17ARAgiNAKCLFYxf8Q2Hc3WzSn5e/ZLwazSpJACg3DiX
uDLsP6ik4IyDauZp1YGZBMM=
=RnmL
-----END PGP SIGNATURE-----

--==_Exmh_1196136023_2838P--
