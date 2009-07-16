Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZGPXYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZGPXYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933574AbZGPXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:24:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38559 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbZGPXYH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:24:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add "VmUsers: N" to /proc/$PID/status
In-Reply-To: Your message of "Thu, 16 Jul 2009 23:27:25 +0200."
             <200907162327.25700.vda.linux@googlemail.com>
From: Valdis.Kletnieks@vt.edu
References: <200907150322.18123.vda.linux@googlemail.com> <48286.1247773600@turing-police.cc.vt.edu>
            <200907162327.25700.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247786645_4382P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 19:24:05 -0400
Message-ID: <63188.1247786645@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247786645_4382P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jul 2009 23:27:25 +0200, Denys Vlasenko said:

> You are right. There is more: the truly accurate accounting
> needs to be per page. Like /proc/$PID/smaps
> and /proc/$PID/pagemap. (However, I am not sure you can
> relize that two processes share a VM by looking
> at these files either)

Hmm.. what if /proc/$PID/<something> reported pairs of virtual/real page
addresses? Then you could identify shared pages by virtue of them having
the same real page frame address..

Of course, with 2G of memory in my laptop, that's 256K 4K pages, and it gets
even messier on machines with macho-RAM installed and lots of processes
running. Lotta pain to get more accurate numbers on what is a very race-prone
number.

> I, indeed, want to have just an N I can divide RSS/VSZ/etc by,
> to get, say, top display which do not mislead user
> into thinking that he has 3 processes with 100 megabyte RSS
> when in reality he has 3 processes sharing a single VM
> with 100 meg RSS.

Thinking about it a bit more - it's probably *usually* possible to sort out
which processes are sharing because if you have 2 sets of shared memory,
they'll *usually* have different RSS values - so the 2 processes with a
count of 2 and an RSS of 179M are one set, and the 2 processes with a count
of 2 and an RSS of 198M are probably another.

Certainly not good enough for chargeback accounting, but good enough if you're
trying to debug a WTF? situation or other "what's going on?" question...


--==_Exmh_1247786645_4382P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKX7aVcC3lWbTT17ARAsJlAKDKINf91qplHPJiEX3oP43kmjmDpgCgi7km
vjrMNU6DlE79SV69oRL/m8I=
=DYg4
-----END PGP SIGNATURE-----

--==_Exmh_1247786645_4382P--
