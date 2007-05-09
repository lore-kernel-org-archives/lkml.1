Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbXEIUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbXEIUOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXEIUOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:14:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53354 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXEIUOY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:14:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - 100% CPU on ksoftirqd/1
In-Reply-To: Your message of "Wed, 09 May 2007 11:12:39 PDT."
             <46420F17.2050106@goop.org>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org> <4123.1178726923@turing-police.cc.vt.edu>
            <46420F17.2050106@goop.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178741608_3418P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 May 2007 16:13:29 -0400
Message-ID: <15321.1178741609@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178741608_3418P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 11:12:39 PDT, Jeremy Fitzhardinge said:
> It always seems to happen on the last CPU; when I run the kernel as Xen
> guest with 4 vcpus, it happens on events/3.

Probably something different - at least once, I've caught it on /0 with
2 real cores online (T7200).  Looking at kernel/softirq.c, the ksoftirqd()
function is basically 2 nested while() loops.  Looks like  either local_softirq_pending()
gets stuck true, but no obvious reason why, or something odd is getting
set in the current-> structure so when we call schedule(), we end up returning
rather than hitting the idle loop.

Off to go see how much mm-bisect I can do before dinnertime - the rest will be
later tonight...


--==_Exmh_1178741608_3418P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQitocC3lWbTT17ARAttRAJ0RtvzCMgBmp05GnEtWpO3xjns4zQCfcnub
jQBTAP6bgUYml7aV43QwBfA=
=ppyi
-----END PGP SIGNATURE-----

--==_Exmh_1178741608_3418P--
