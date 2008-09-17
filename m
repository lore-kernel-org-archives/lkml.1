Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYIQFkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYIQFkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYIQFjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:39:52 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50415 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYIQFjv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:39:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alessio Sangalli <alesan@manoweb.com>
Cc: Ben Nizette <bn@niasdigital.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
In-Reply-To: Your message of "Tue, 16 Sep 2008 22:27:41 PDT."
             <48D0954D.4070302@manoweb.com>
From: Valdis.Kletnieks@vt.edu
References: <48CEC71F.3000006@manoweb.com> <20080916093513.GF1916@fluff.org.uk> <48CFEF3F.5040901@manoweb.com> <1221604022.3598.4.camel@moss.renham> <48D03811.9070805@manoweb.com> <24229.1221619342@turing-police.cc.vt.edu>
            <48D0954D.4070302@manoweb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221629978_32017P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 01:39:38 -0400
Message-ID: <32819.1221629978@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221629978_32017P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Sep 2008 22:27:41 PDT, Alessio Sangalli said:

> Well I should ask the details to the hardware engineers but it's like a
> separate channel than the one used for main memory. It is not cacheable
> either. To the CPU, it just appears to be mapped at some location on the
> addressable space. Accessing this TCM will not have any impact on main
> memory access, so bursts etc won't be interrupted; other than that, TCM
> has double the bandwidth than standard memory - but it's tiny in size,
> something like 8 to 32kB as I mentioned earlier.

Ah.  So it's basically just super-fast memory that can be accessed without
going through the usual memory bus.  Sounds like the cycle of reincarnation
strikes again - 30ish years ago, the DEC PDP10/20 processors implemented the
first few locations of memory in fast (for the time) chips, and then mapped
the general purpose registers onto it.  A favorite trick would be to copy a
small loop into locations 0-7 and then branch to it - basically executing
from the general registers.  The *real* fun started when people started doing
self-modifying code by doing arithmetic/logical operations on registers. ;)

Would it be more of a performance win to use the 8-32K to store speed-critical
code rather than a FIFO?  Just another idea for what to use it for, but that
would likely require a different API...

--==_Exmh_1221629978_32017P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0JgacC3lWbTT17ARAhgQAKDd8Xt4X7g/QCoKYlev+AvTBFiCBwCeJEi0
xpQH1wGOOEYXOdhy3dMwLiQ=
=KjLG
-----END PGP SIGNATURE-----

--==_Exmh_1221629978_32017P--
