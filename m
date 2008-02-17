Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYBQL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYBQL2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYBQL2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:28:01 -0500
Received: from master.altlinux.org ([62.118.250.235]:2623 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYBQL2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:28:00 -0500
X-Greylist: delayed 1956 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 06:27:59 EST
Date: Sun, 17 Feb 2008 13:55:20 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: Andrew Buehler <abuehler.kernel@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Message-ID: <20080217105520.GA4628@atlas.home>
References: <Pine.LNX.4.44L0.0802161207160.3828-100000@iolanthe.rowland.org> <47B756B5.7070901@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <47B756B5.7070901@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2008 at 04:33:41PM -0500, Andrew Buehler wrote:
> The associated dmesg (obtained yesterday from booting with the
> Flash drive connected) is attached.

This dmesg shows that ACPI is not enabled in your kernel config - most
likely this is the problem.  Try to enable it:

 1) In the "Power management options" submenu enable the "Power
    Management support" option (CONFIG_PM) - if this option is
    disabled, you will not see the option to enable ACPI below.

 2) In the same submenu enable the "ACPI (Advanced Configuration and
    Power Interface) Support" option (CONFIG_ACPI).

Without ACPI support the kernel can use legacy interrupt routing
tables from BIOS, but on new systems these tables are often broken due
to lack of testing (because all modern operating systems use ACPI
instead of these legacy tables).

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHuBKYW82GfkQfsqIRAn7lAKCLI1Hqzb3ZLL6MCaRjfOAIJSknRwCdGUxG
3FPtUeL7NNA+fI9UNNrp0jA=
=CI1M
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
