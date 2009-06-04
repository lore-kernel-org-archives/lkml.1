Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZFDO0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZFDO0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZFDO0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:26:16 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFDO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:26:15 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <200906032351.01900.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906032305.07551.rjw@sisk.pl> <1244064315.22576.5.camel@johannes.local>
	 <200906032351.01900.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OowC4ytkJPBWlB463KAI"
Date: Thu, 04 Jun 2009 16:26:10 +0200
Message-Id: <1244125570.22576.78.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OowC4ytkJPBWlB463KAI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Alright, I have managed to trace this.

http://johannes.sipsolutions.net/files/hibernate-delay-dmesg.txt

has the dmesg, you can clearly see the delay:
[50265.143330] ACPI: Waking up from system sleep state S4
[50265.679141] HDA Intel 0000:00:08.0: restoring config space at offset 0x1=
 (was 0xb00006, writing 0xb00002)
[50265.689525] forcedeth 0000:00:0a.0: restoring config space at offset 0x1=
 (was 0xb00003, writing 0xb00007)
[50265.699775] ahci 0000:00:0b.0: restoring config space at offset 0x1 (was=
 0xb00403, writing 0xb00407)
[50286.294910] pci 0000:00:03.2: PME# disabled

I managed to get an entire function trace between

[50265.143330] ACPI: Waking up from system sleep state S4

and

[50290.439040] Restarting tasks ... done.

which I've uploaded to

http://johannes.sipsolutions.net/files/hibernate-delay-trace.bz2

(WARNING: uncompresses to 574MiB!)

I'm not sure why the timing in there doesn't show the delay, Steven was
taking a look at that.

johannes

--=-OowC4ytkJPBWlB463KAI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ9l/AAoJEODzc/N7+QmasBsP/ioLk91yR6uHRv9vCjymR0xp
ICoifV8KWFUqkEc8bnh9WXfKyMU29EzPNkarWalfTec8DryRqzGa1cEZmXEAbFen
b3qc61md5IGrh1ZNOKJKNcyGBTZ128sV4vj0ss8Q5lymx+0iSJlqmAfAJ5tf0vi7
XsP2+P8xBbdlwJatsFmX6wa+RwriiB9/JqhJyCxP2w8V/qSeuWePnITxTL4rD/NQ
MzDDSK6J6Zzz0wjaa9qNd8PNl6Q18dOlc4KrZWbknyhJ3l57TLHTmlpCVys8TGRR
WvjV8jtFU7rVqMvtalrCZ+K227WAt+dVofGb9G2NYzctYz8o5MkTqK22J5M8ozve
IPFp2X0qHbglUK9w/DHuzI9UxFTj9G87jBNj+xroOLrlI9lYp7hgJrIK19/To7Ib
rz7EcG6qUBUh8IFJRBdn83/mfz4BR1zqlB2StlvU1u6eM1IFMcCLrwpjn7VWvdoj
PeC5BaJFGa4rX7mu9+aQi8QbpkRcVIQ2yeF75vbGlz5lezKqvn/KQnWBNCVQaJ5Q
fmIJWaB0hX6udXcPNfOOwZ6kj9Xs97DemQw4Y0o+jQe0ae/0cy/vosUtN1ipGe8u
XP0GRK+nD7/z1ldiK8MdqEXbrfV87TXoKplfIcQtxR9ryZTcp/jLigxcYGARwVm9
8TeQhYM18sc7IN3Zmqcj
=OCDZ
-----END PGP SIGNATURE-----

--=-OowC4ytkJPBWlB463KAI--

