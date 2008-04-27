Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYD0Lav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYD0Lav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYD0Lak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:30:40 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:36484 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742AbYD0Laj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:30:39 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080426195407.GA13729@elte.hu>
References: <20080426185516.GA32364@elte.hu>
	 <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	 <20080426195407.GA13729@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+hOmJEAK9bhI1z2Saw5o"
Date: Sun, 27 Apr 2008 12:21:11 +0100
Message-Id: <1209295271.2063.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [git pull] "big box" x86 changes, boot protocol
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+hOmJEAK9bhI1z2Saw5o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-04-26 at 21:54 +0200, Ingo Molnar wrote:
> diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
> index 2eb1610..0fac346 100644
> --- a/Documentation/i386/boot.txt
> +++ b/Documentation/i386/boot.txt
> @@ -42,6 +42,8 @@ Protocol 2.05:        (Kernel 2.6.20) Make protected mo=
de kernel relocatable.
>  Protocol 2.06: (Kernel 2.6.22) Added a field that contains the size of
>                 the boot command line
> =20
> +Protocol 2.09: (kernel 2.6.26) Added a field of 64-bit physical
> +               pointer to single linked list of struct setup_data.
> =20

How about this. I can redo against current Linus but that will need
fixups here.

=46rom cfed8d4043fc03ed948518076db602919b111a16 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Sun, 27 Apr 2008 12:19:11 +0100
Subject: [PATCH] Backfill x86 boot protocol documentation.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 Documentation/i386/boot.txt |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 0fac346..86fbbd0 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -40,9 +40,17 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode kerne=
l relocatable.
 		Introduce relocatable_kernel and kernel_alignment fields.
=20
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
-		the boot command line
+		the boot command line.
=20
-Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
+Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised boot protocol.
+		Introduced hardware_subarch and hardware_subarch_data
+		and KEEP_SEGMENTS flag in load_flags.
+
+Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
+		payload. Introduced payload_offset and payload length
+		fields to aid in locating the payload.
+
+Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 		pointer to single linked list of struct	setup_data.
=20
 **** MEMORY LAYOUT
--=20
1.5.5.1



--=20
Ian Campbell

Computer Science is the only discipline in which we view adding a new wing
to a building as being maintenance
		-- Jim Horning

--=-+hOmJEAK9bhI1z2Saw5o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIFGGnM0+0qS9rzVkRArAvAJ9H2F7FOLpwzp7YZkKTpDcrYqWQMwCg72Xe
lEy+mm1CtEdxwmauNBn7VPM=
=AOpt
-----END PGP SIGNATURE-----

--=-+hOmJEAK9bhI1z2Saw5o--

