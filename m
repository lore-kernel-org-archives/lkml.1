Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZBADOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZBADOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZBADOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:14:23 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59942 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZBADOW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:14:22 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Angelo Borsotti <angelo.borsotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: processes/threads monitor
In-Reply-To: Your message of "Sat, 31 Jan 2009 22:57:36 +0100."
             <541298b90901311357o593a4339t46a44e8933bb1a6b@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <541298b90901311357o593a4339t46a44e8933bb1a6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233458059_3558P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 31 Jan 2009 22:14:20 -0500
Message-ID: <13755.1233458060@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233458059_3558P
Content-Type: text/plain; charset=us-ascii

On Sat, 31 Jan 2009 22:57:36 +0100, Angelo Borsotti said:

> The need occurs on Linux installations in which there are some process
> control applications,
> or some continuous sever applications that need some resilience
> towards process failures.
> When a process providing an essential service terminates, come
> "process monitor" would
> create it again, restoring the service automatically (and without the
> need for human intervention).

Usually, this is easily done with any sane /sbin/init, by sticking a
line in /etc/inittab that looks like:

vip:12345:respawn:/usr/bin/my-important-process

It terminates, it gets respawned.

The *tricky* case isn't dealing with a process that manages to terminate,
the real uglyness starts when you have a process that becomes wedged up
but failing to terminate (which can happen for any number of reasons - it
went into an infinite loop, or two threads managed to deadlock, or....)

And unfortunately, there's no clean general-purpose way to do *that*, mostly
because there's no good config language that allows you to code stuff like
"if Apache wedges up and fails to respond in 0.5 seconds or less, shoot it
and restart it, unless you have detected that the failure is actually due to
unrelated cause A, in which case do X, or if B happened, then do Y, or if
C happened, then do Z, or...."

If you have real requirements for all-the-time continuous operations, then
you don't *really* want a monitor anyhow.  What you *want* is redundant
hardware with some good high-availability clustering software to do hot failover.

Because if your server comes to a screeching halt because a memory card or
other hardware just bit the dust, that monitor isn't going to do *anything* for you.

Plus - if you can't do failover, how do you do a system upgrade if needed?

--==_Exmh_1233458059_3558P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJhROLcC3lWbTT17ARAnO+AKCqbnwoWsEwAOlXbXG4ticX4tKRtwCeIAHh
jCPxBom3C5tzbtJJnWnlnRg=
=3mRy
-----END PGP SIGNATURE-----

--==_Exmh_1233458059_3558P--
