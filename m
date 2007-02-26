Return-Path: <linux-kernel-owner+w=401wt.eu-S1161346AbXBZW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbXBZW7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161351AbXBZW7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:59:22 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:40652 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161346AbXBZW7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:59:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=TXdb/M/IM+kLm2PNWmSvDhvruvizPvElMbbCRGiIV1TFdnwOg6DEjHOCkQNWwyWW+2NJGJjR7oD6PuCb4bBOstw5c45bbJwxyv+bkWKSe0LebO4/3wPu7kxW6zvrQCp+;
Message-ID: <45E3663B.4000701@simon.arlott.org.uk>
Date: Mon, 26 Feb 2007 22:59:07 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: ebiederm@xmission.com
Subject: [irq: Remove set_native_irq_info] !CONFIG_SMP regression
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigB0E55D193ABA17A22B76B856"
Reply-To: Simon Arlott <58022e3be4e86309571hlooq00057abw@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0E55D193ABA17A22B76B856
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

9f0a5ba5508143731dc63235de19659be20d26dc is first bad commit
commit 9f0a5ba5508143731dc63235de19659be20d26dc
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri Feb 23 04:13:55 2007 -0700

    [PATCH] irq: Remove set_native_irq_info

    This patch replaces all instances of "set_native_irq_info(irq, mask)"=

    with "irq_desc[irq].affinity =3D mask".  The latter form is clearer
    uses fewer abstractions, and makes access to this field uniform
    accross different architectures.



arch/i386/kernel/io_apic.c: In function `setup_IO_APIC_irqs':
arch/i386/kernel/io_apic.c:1357: error: structure has no member named `af=
finity'
arch/i386/kernel/io_apic.c: In function `io_apic_set_pci_routing':
arch/i386/kernel/io_apic.c:2878: error: structure has no member named `af=
finity'


The original version was an empty function if !CONFIG_SMP, struct irq_des=
c only has 'affinity' on SMP.

--=20
Simon Arlott


--------------enigB0E55D193ABA17A22B76B856
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBReNmQqRtx1WjQ8ihAQpWHhAAhDiVAXHGvoQTIbT9ouPaGaPVktb9Sfwt
/nhHZW2i2KFmRI/jHaZU2BzbKMVhHLL3X/McNpqX1fb2X31gDFuldUnKPZKqW94p
nGPq+2o4FvryRuImstyaLw599LSxi/1miWUNaWRW63qV/xTr1/rjqRb9XfFi/UFt
f5Qj3K+NpS2M1fRybnXsel8PVGgUJrK8KY3ie0HF1pKdu1hkwmGdVVaaeRoEG4Nd
apAaPjZzfMdaZ5KUnPs8Itls5U5M7Zrd6k9roqcfQt/6mHwMf6v6SbJuQXkB1ITo
u2ZjBMGWqB/X6nFeU5zva29i8tWneHDmT3kcDUvTgV91tobHttGuZ9oeKtPbKE4V
sX4uN3y7qttqAZJS0Mk+EROlm3pnJViDm4BLgA9Y8VGDFSwkUVYqI3PNzoXF7NVM
dJOLGSxHmm8hZ0G9ufn0ggwgAUANAqEZ6EtSGc9sWMj5b/w1JXurMY1cv8b5crEL
O8/qnXaGfljfcdtpEpno4/yFSZNFfqOs9QHpYGzpryBLghHbZffq9NPsz2YKXkrs
WnBN6WutNxfqqRGsPCFopLZHvDJIxSMOKduVoZHpfBTygc99ThpQVppVkEsBdWLI
lN/rKE+yg0tMnUW0Ioa/7HI/vm4SuwDd+ZyV0kTNo/3OCMvgAyGpmsWflSIe/ukf
xqri52jnFVE=
=6nlW
-----END PGP SIGNATURE-----

--------------enigB0E55D193ABA17A22B76B856--
