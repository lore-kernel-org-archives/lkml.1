Return-Path: <linux-kernel-owner+w=401wt.eu-S939447AbXG3Xxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939447AbXG3Xxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763689AbXG3Xxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:53:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55412 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbXG3Xxa (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:53:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Fri, 27 Jul 2007 16:43:13 MDT."
             <200707271643.14028.bjorn.helgaas@hp.com>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <5208.1185508832@turing-police.cc.vt.edu> <23912.1185542889@turing-police.cc.vt.edu>
            <200707271643.14028.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185839599_32560P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Jul 2007 19:53:19 -0400
Message-ID: <5287.1185839599@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185839599_32560P
Content-Type: text/plain; charset=us-ascii

On Fri, 27 Jul 2007 16:43:13 MDT, Bjorn Helgaas said:

> I don't know why tpm_tis_init() is messing around trying different
> IRQs between 3 and 16.  That looks suspiciously x86-dependent.
> 
> Maybe if you don't have PNP (though I doubt TPMs exist on any
> pre-PNPBIOS machines) the "check-IRQ" loop would be necessary.

Well, it's a 6 month old Dell Latitude, and PNP is most certainly there,
as a number of other things get configured using it as well.

> But you're using the PNP probe, and PNP should just tell you what
> IRQ the device is configured for (and whether the IRQ can be
> shared -- see 8250_pnp.c for an example).
> 
> The BIOS should have configured the TPM IRQ, and if we go and
> mess with that IRQ setting without going through the PNP interface,
> e.g., the ACPI _SRS method, we're liable to mess something up.  The
> TPM is often behind a few bridges, and if the bridge has any IRQ
> routing configuration, only the BIOS knows how to keep that in
> sync with the TPM IRQ configuration.
> 
> > Just for the record, I see this in /sys:
> > 
> > % cat /sys/bus/pnp/devices/00:0e/id
> > BCM0102
> > PNP0c31
> 
> What's in /sys/bus/pnp/devices/00:0e/resources?

% cat /sys/bus/pnp/devices/00:0e/resources
state = active
io 0x378-0x37f
io 0x778-0x77b
irq 7
dma 1

IRQ 7.  That would certainly explain why I was seeing massive timeouts
when the driver chose to use IRQ 3. ;)

I'll test-drive your patch from Monday's e-mail when I get home tonight.


--==_Exmh_1185839599_32560P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGrnnvcC3lWbTT17ARAh7ZAJ4hR4E3vbZQ8tCbJRawcPgM5ca7BgCgog3y
uRu7loOuWMoS7G/nwcaOaWE=
=mFNQ
-----END PGP SIGNATURE-----

--==_Exmh_1185839599_32560P--
