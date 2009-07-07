Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZGGApY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZGGApY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZGGApM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:45:12 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48972 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZGGApL (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:45:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arnd Bergmann <arnd@arndb.de>
Cc: michal.simek@petalogix.com, Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
In-Reply-To: Your message of "Mon, 06 Jul 2009 16:16:11 +0200."
             <200907061616.12220.arnd@arndb.de>
From: Valdis.Kletnieks@vt.edu
References: <4A4DFB77.1080700@petalogix.com> <20090706121455.GA16908@linux-sh.org> <4A51F3F3.6040501@petalogix.com>
            <200907061616.12220.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246927497_3046P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Jul 2009 20:44:57 -0400
Message-ID: <105602.1246927497@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246927497_3046P
Content-Type: text/plain; charset=us-ascii

On Mon, 06 Jul 2009 16:16:11 +0200, Arnd Bergmann said:

> What happens in a simple user space program that mmaps the same
> page to two addresses? Something like
> 
> #include <sys/mman.h>
> #include <fcntl.h>
> int main(void)
> {
> 	int fd = open("existing-4k-file", O_RDWR);
> 	char *p1 = mmap(0, 4096, PROT_READ | PROT_WRITE,
> 				MAP_SHARED, fd, 0);
> 	char *p2 = mmap(p1 + 4096, 4096, PROT_READ | PROT_WRITE,
> 				MAP_SHARED | MAP_FIXED, fd, 0);
> 
> 	*p1 = 0xaa; *p2 = 0x55;
> 
> 	return *p1; /* returns 0xaa if broken, 0x55 if correct */
> }

Strictly speaking, doesn't that need a barrier of some sort between the two
assignments?  I mean, how is gcc supposed to intuit that p1 and p2 alias
each other and it needs to reload *p1 before returning that value?

(And in more complicated code, I could even see the compiler re-ordering those
two assignments, so the in-file value is different as well as the return; value)


--==_Exmh_1246927497_3046P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKUpqJcC3lWbTT17ARAvPDAJ4g0SupREDNuIl1wjEqFIcy5X6NaQCfQr7f
0kk4F9TjsIAuVNY2rd6J1rk=
=O+9H
-----END PGP SIGNATURE-----

--==_Exmh_1246927497_3046P--
