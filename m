Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXGHDuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXGHDuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbXGHDtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:49:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34575 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbXGHDtc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:49:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq 'choice' Kconfig oddness in 2.6.22-rc6-mm1..
In-Reply-To: Your message of "Sat, 07 Jul 2007 15:50:01 +0900."
             <20070707065001.GA15181@inferi.kami.home>
From: Valdis.Kletnieks@vt.edu
References: <6443.1183782910@turing-police.cc.vt.edu>
            <20070707065001.GA15181@inferi.kami.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1183866569_3529P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Jul 2007 23:49:29 -0400
Message-ID: <17231.1183866569@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1183866569_3529P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Jul 2007 15:50:01 +0900, Mattia Dongili said:
> On Sat, Jul 07, 2007 at 12:35:10AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > So I was looking at drivers/cpufreq/Kconfig, and wondering...
> > 
> > Is there a specific reason why we have a 'choice' clause that allows selecting
> > 'performance' or 'userspace' as the default governor, and no obvious way to
> > select powersave, ondemand, or conservative as a default? Or was this an
> 
> Yes, ondemand and conservative may refuse to load/work on systems with
> a high transition latency and that is sometimes discovered only at
> runtime. This makes them not selectable as default governors.

D'Oh! :)  I was trying to set ondemand as the default, only after verifying
that ondemand works as desired on my laptop.  I forgot that we probably need
to also allow for people who don't test before making things default....

> > oversight I should cook up a patch for?  Looks like the Kconfig and a bit
> > of cut-n-paste in include/linux/cpufreq.h is all that's needed?
> 
> No, some more work is needed (e.g.: falling back to a different governor
> if the selected fails). Thomas Renninger has posted patches on
> cpufreq-devel to accomplish that.

OK - I'll keep an eye open and test them out whenever they hit -mm.
In the meantime, an 'echo ondemand' into the right /sys file is working
for me as a workaround.


--==_Exmh_1183866569_3529P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGkF7JcC3lWbTT17ARAgWJAKCT3r85ch8thwsnciab5NeE3YkmvwCg7hGq
f+9jNsMUSg/yloyIfSpyb1A=
=MZre
-----END PGP SIGNATURE-----

--==_Exmh_1183866569_3529P--
