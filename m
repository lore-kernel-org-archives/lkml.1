Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbZD2DPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbZD2DPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZD2DPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:15:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56088 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZD2DPk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:15:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Debug only with printk ?
In-Reply-To: Your message of "Tue, 28 Apr 2009 23:27:42 +0200."
             <2d05c4580904281427r65282bb2m5dd8c9f8a2de5363@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <2d05c4580904281427r65282bb2m5dd8c9f8a2de5363@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240974935_4310P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 23:15:35 -0400
Message-ID: <81278.1240974935@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240974935_4310P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Apr 2009 23:27:42 +0200, Dragoslav Zaric said:
> I am relatively new in linux kernel and since debugging is key
> element of programming, I am wondering is it really necessary
> to use various debugging tools for kernel debugging ?

'git bisect' and friends are your friends if you're trying to track down
a bug in somebody else's code.

It's not *mandatory* to use other tools, but it certainly helps.

> Is simple printing with printk enough to debug any kind of kernel problem,
> and if not, what are the cases when printk is not enough ?

Usually, printk's are sufficient *if* you can use them.  Times when this
may not be true:

1) Debugging an early-boot crash, before even the earlyprintk stuff is alive.

2) "Add a printk, recompile, reboot" gets pretty boring pretty fast, so
it may be a *lot* faster if you can use one of the kernel debugging/tracing
tools to do "Well, maybe we should check this... or this.. or wait, how
about *this*?" testing.

3) If you're trying to debug an issue on a production server, you may not
have the *option* to do a lot of compile/reboot cycles, and be forced to
use whatever debug/trace support is present in the already-running kernel.

> Also, is there possibility when using debugging tools to affect
> kernel environment, because debugging tool will also take cpu time and
> memory resources ?

If I had a <monetary unit> for every time when even adding a printk call
was enough to change the timing and cause a Heisenbug to change its behavior,
I'd have a lot of monetary units.

Yes, debugging tools and printks will change code and data offsets and timing
so data overlays and race conditions change or even dissapear/reappear.

--==_Exmh_1240974935_4310P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ98ZXcC3lWbTT17ARAtHIAKDWoSZFKJ1eBH0nT+6TILsRwnLKnACfQa7t
RTp49EBAciYeFCztchZevFE=
=S8/9
-----END PGP SIGNATURE-----

--==_Exmh_1240974935_4310P--
