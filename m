Return-Path: <linux-kernel-owner+w=401wt.eu-S1765855AbXFFQJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765855AbXFFQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbXFFQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:08:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38026 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXFFQI7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:08:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
In-Reply-To: Your message of "Wed, 06 Jun 2007 02:07:37 PDT."
             <20070606020737.4663d686.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070606020737.4663d686.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181146132_3541P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Jun 2007 12:08:52 -0400
Message-ID: <7929.1181146132@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181146132_3541P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jun 2007 02:07:37 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/

This one died a horrid death at boot time - console log indicates it found the
hard drive OK, found the 2 partitions on it.  But when the initrd ran a
'lvm vgscan', it didn't find the LVM2 space on /dev/sda2, so it panic'ed when
it fell off the end of the initrd because the root= wasn't there.

My first guess for blame:

gregkh-driver-sysfs-allocate-inode-number-using-ida.patch

as that's awfully similar to gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
that broke 'lvm vgscan' for me in the same way on 21-rc7-mm[12].

I'll hopefully get a chance to revert that one and test later today - a quick
'patch -p1 -R --dry-run' shows a number of conflicts that will need hand-fixing
at the very least.

--==_Exmh_1181146132_3541P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGZtwUcC3lWbTT17ARAs2aAKDubpaDwNYfdgB0/ZbD9NlgDLy7agCbBtzU
FgWESESoej1xNhAiIx8nvnI=
=lG2z
-----END PGP SIGNATURE-----

--==_Exmh_1181146132_3541P--
