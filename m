Return-Path: <linux-kernel-owner+w=401wt.eu-S934720AbXGaVcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbXGaVcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765739AbXGaVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:32:14 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43580 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXGaVcN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:32:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Tue, 31 Jul 2007 14:01:21 MDT."
             <200707311401.22158.bjorn.helgaas@hp.com>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <5287.1185839599@turing-police.cc.vt.edu> <17955.1185907709@turing-police.cc.vt.edu>
            <200707311401.22158.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185917503_12501P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 17:31:43 -0400
Message-ID: <29677.1185917503@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185917503_12501P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <29667.1185917495.1@turing-police.cc.vt.edu>

On Tue, 31 Jul 2007 14:01:21 MDT, Bjorn Helgaas said:

> So, the BIOS is telling us that at least as currently configured, the
> TPM can't use interrupts.  /sys/devices/pnp0/00:0f/options should have
> all the *possible* TPM configurations.  I would guess that none of them
> shows an IRQ either.

Hmm.. Oddness. Looks empty:

# cat /sys/devices/pnp0/00\:0f/options | wc
      0       0       0

Or is that expected if the chipset has one cast-in-stone/ROM config?

> In general, if the BIOS says there's no interrupt, we should not poke
> around looking for one unless we think there's a BIOS defect.  I think
> you said that under 2.6.22-rc6-mm1, the TPM didn't find a working
> interrupt either.

> Yup, I hadn't considered the case of BIOS not telling us an interrupt
> for the device.  In that case, I think we should force interrupts off
> as you suggest.  Here's the patch I would propose:

Patch tested, and seems to decide to initialize in polled mode on my
machine, without having to do any /etc/modprobe.conf 'interrupts=0'.
I'm able to run the tpm_demo program from libtpm-2.0, so /dev/tpm0 does
seem to be operational.

You can stick this on the patch and pass it along:

Tested-By: <valdis.kletnieks@vt.edu>

but I'd suggest running a regression test against a chipset that *does*
do IRQs before sending it upstream (if you haven't already)...

--==_Exmh_1185917503_12501P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGr6o/cC3lWbTT17ARAp91AJ4zWdGDZVOEbU5WoT3ALk/u+fc/1wCeO11a
KWKPIF2hFqSWH9kifRAx4KU=
=DDwy
-----END PGP SIGNATURE-----

--==_Exmh_1185917503_12501P--
