Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZGUMSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZGUMSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZGUMSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:18:22 -0400
Received: from place.holder ([209.9.226.146]:55432 "EHLO grsecurity.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbZGUMSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:18:21 -0400
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 08:18:21 EDT
Date: Tue, 21 Jul 2009 07:51:50 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       sds@tycho.nsa.gov, jmorris@namei.org, dwalsh@redhat.com,
       cl@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090721115150.GB6978@grsecurity.net>
References: <1248132223.2654.278.camel@localhost> <20090720204848.5f37c92a@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <20090720204848.5f37c92a@infradead.org>
User-Agent: Mutt/1.5.9i
From: spender@grsecurity.net (Brad Spengler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> one option is to allow the page to be mapped, but only as
> non-executable... in DOS that memory isn't where code lives anyway...

Bad idea.

My exploit (and many other null ptr dereference exploits) still will
work with a non-executable NULL mapping.  The exploit I released was
different from the one I did in 2007 in that in 2007 I abused a function
pointer in the structure that was being pointed to and located at NULL.
In this case, no function pointers were used at all in the structure
being pointed to.  I turned a 'trojaned data' situation into an
arbitrary OR of 0x1 and then into arbitrary code execution.

For instance, if I targeted the 3rd byte in the mmap file_operation
fptr, that would have given me a target userland address of 0x10000.
If I targeted the 4th byte, it would have given me 0x1000000, neither of
which fall under mmap_min_addr protection

Furthermore, without an actual NX implementation enforcing the lack of
PROT_EXEC, the kernel will execute in the region just fine.

-Brad

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKZavVmHm2SUJF1GoRAgA4AKCDQCWGjT+959AcG/kKM9ArzfPsCgCghrVj
zipil148tO3buJp9GV76CyQ=
=Qtlr
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
