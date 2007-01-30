Return-Path: <linux-kernel-owner+w=401wt.eu-S964933AbXA3AYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbXA3AYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXA3AYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:24:22 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45071 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964933AbXA3AYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:24:21 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: ak@suse.de
Subject: [patch] use __u32 in asm-x86_64/msr.h
Date: Mon, 29 Jan 2007 19:25:08 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kBpvFVEbcu47uzB"
Message-Id: <200701291925.08670.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kBpvFVEbcu47uzB
Content-Type: multipart/signed;
  boundary="nextPart9291398.Lti1WEfqaC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9291398.Lti1WEfqaC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

the checking_wrmsrl() macro in asm-x86_64/msr.h which is exported to usersp=
ace=20
utilizes the u32 type instead of __u32 ... trivial attached patch fixes that
=2Dmike

--nextPart9291398.Lti1WEfqaC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARb6QZEFjO5/oN/WBAQLuew//RaMb9VfSYRaKk6bE65Yz2VzFbA4WqtBp
c3lTOcpkGig4bjsTKX7v2vmib3Eode58JEHAvt9nlaXKYBpE7rnV6GzW7cSUGREI
lilQTsP+0CGo2vSagOU6EFGwkDQDJ7Q0q0NcP0d5eLjOSh7EiIZel7TOHPhYxTef
QhVILmmtB9iHjwDqrvuigIfUfBBodjJe2H+1v31YPAx7+ST0Jd77o+OHualy6yKb
OqPVT8w8TgGf64m/SdSaPg0A/LsVUt4FIRWq7qEy1zMFlyYzKsAnyCXLHwklBWEO
2anYmbPr7VE9E3mwhM/w2OGbuTe91P48LCpFruZB9OGRqDjzcZ5kMpAn0yhLyn3q
ydlkpCwCf/1hQ7hsLTdFKamfnHHp6HxXWwkNMLRLCtn42e0PJsYQVBFw7iAS/lZx
KkcU6YZbYgldbikp+893ra5+BuJD3W094x2076tzCQqW0bla5QEoUtE7adhG+Eoc
O6fcoYtvQ5MZJHV+zViR8TNAZ6TIQg7bDrkebxa6cjKmUP77LTcicQJOawB7er9H
y+GeEYnrfSzXoVo5J6VbIloZkUH0aTRNxSa75TnC11DbZfHg7qZqZTbG5PzSNTH0
d6sK4ctVt6K3JE305JVhigeBdAt67AstbvcMB4aAVUCXBDCWuvf2a+PseDOYktOE
iLhkkuRor2g=
=mg/9
-----END PGP SIGNATURE-----

--nextPart9291398.Lti1WEfqaC--

--Boundary-00=_kBpvFVEbcu47uzB
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-use-__-types-in-x86-64-msr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-use-__-types-in-x86-64-msr.patch"

Use __u32 rather than u32 in checking_wrmsrl() exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

--- a/include/asm-x86_64/msr.h
+++ b/include/asm-x86_64/msr.h
@@ -2,6 +2,9 @@
 #define X86_64_MSR_H 1
 
 #ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -43,7 +46,7 @@
 		     : "c" (msr), "0" (a), "d" (b), "i" (-EFAULT)); \
 	ret__; })
 
-#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
+#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(__u32)(val),(__u32)((val)>>32))
 
 #define rdmsr_safe(msr,a,b) \
 	({ int ret__;						\

--Boundary-00=_kBpvFVEbcu47uzB--
