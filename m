Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYJ0WSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYJ0WSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYJ0WSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:18:23 -0400
Received: from aybabtu.com ([69.60.117.155]:42360 "EHLO aybabtu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYJ0WSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:18:22 -0400
X-Greylist: delayed 1994 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 18:18:22 EDT
Date: Mon, 27 Oct 2008 22:44:45 +0100
From: Robert Millan <rmh@aybabtu.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] make firmware/dsp56k/bootstrap.asm buildable on a56
Message-ID: <20081027214445.GA20050@thorin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
Organization: free as in freedom
X-Message-Flag: Worried about Outlook viruses? Switch to Thunderbird! www.mozilla.com/thunderbird
X-Debbugs-No-Ack: true
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


[ Please CC me, I'm not subscribed ]

Hi!

Attached patch makes firmware/dsp56k/bootstrap.asm buildable on a56, the
free Motorola DSP56001 assembler (http://www.zdomain.com/a56.html).

Summary of changes:

  - Remove '<' and '>' candy (they specify explicit addressing modes,
    which a56 don't grok, but uses implicitly anyway).

  - Replace 'move' with 'movem' when accessing program memory.

  - Rename a few labels to avoid duplicates (which a56 can't handle).

--=20
Robert Millan

  The DRM opt-in fallacy: "Your data belongs to us. We will decide when (and
  how) you may access your data; but nobody's threatening your freedom: we
  still allow you to remove your data and not access it at all."

--jI8keyz6grp/JLjh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dsp56k_bootstrap.diff"
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Robert Millan <rmh@aybabtu.com>

diff --git a/firmware/dsp56k/bootstrap.asm b/firmware/dsp56k/bootstrap.asm
index 10d8919..a411047 100644
--- a/firmware/dsp56k/bootstrap.asm
+++ b/firmware/dsp56k/bootstrap.asm
@@ -51,19 +51,19 @@ start   jmp     <$40
         ; Copy DSP program control
         move    #real,r0
         move    #upload,r1
-        do      #upload_end-upload,<_copy
-        move    P:(r0)+,x0
-        move    x0,P:(r1)+
-_copy   movep   #>4,X:<<M_HCR
-        movep   #>$c00,X:<<M_IPR
+        do      #upload_end-upload,_copy
+        movem    P:(r0)+,x0
+        movem    x0,P:(r1)+
+_copy   movep   #4,X:<<M_HCR
+        movep   #$c00,X:<<M_IPR
         and     #<$fe,mr
         jmp     upload
=20
 real
         org     P:$7ea9
 upload
-        movep   #>1,X:<<M_PBC
-        movep   #>0,X:<<M_BCR
+        movep   #1,X:<<M_PBC
+        movep   #0,X:<<M_BCR
=20
 next    jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,A
@@ -81,18 +81,18 @@ _get_length
         cmp     x0,A
         jeq     load_Y
=20
-load_P  do      y0,_load
+load_P  do      y0,_load_P
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,P:(r0)+
-_load   jmp     next
-load_X  do      y0,_load
+_load_P jmp     next
+load_X  do      y0,_load_X
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,X:(r0)+
-_load   jmp     next
-load_Y  do      y0,_load
+_load_X jmp     next
+load_Y  do      y0,_load_Y
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,Y:(r0)+
-_load   jmp     next
+_load_Y jmp     next
=20
 upload_end
         end

--jI8keyz6grp/JLjh--

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJBjZNC19io6rUCv8RAp3UAJ9VCYx4tHlDNZ8rwaspCLrFGZd4GgCfVvhL
F+HpLnL15mugkd9dVw/hjdM=
=lpUz
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
