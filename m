Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZABK0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZABK0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZABK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:26:01 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49822 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZABK0A (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:26:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-mmotm1230 drivers/acpi/hardware/hwsleep.c warning msg
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230891954_3417P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 05:25:54 -0500
Message-ID: <28730.1230891954@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230891954_3417P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

In mmotm1230 the linux.next patch, most likely via this commit:

commit ecd196686aee5028f71ee09072c8581c7293a847
Author: Len Brown <len.brown=40intel.com>
Date:   Fri Dec 19 03:53:37 2008 -0500

    ACPICA: disable ACPI 2.0 _GTS/_BFS support

added some warning messages:

  CC      drivers/acpi/hardware/hwsleep.o
drivers/acpi/hardware/hwsleep.c: In function =E2=80=98acpi_enter_sleep_st=
ate=E2=80=99:
drivers/acpi/hardware/hwsleep.c:231: warning: unused variable =E2=80=98ar=
g=E2=80=99
drivers/acpi/hardware/hwsleep.c:230: warning: unused variable =E2=80=98ar=
g_list=E2=80=99
drivers/acpi/hardware/hwsleep.c: In function =E2=80=98acpi_leave_sleep_st=
ate_prep=E2=80=99:
drivers/acpi/hardware/hwsleep.c:471: warning: unused variable =E2=80=98ar=
g=E2=80=99
drivers/acpi/hardware/hwsleep.c:470: warning: unused variable =E2=80=98ar=
g_list=E2

If we're going to =23ifdef-wrap the code, let's do the variables involved=

as well, so we don't get warnings.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

--- linux-2.6.28-mmotm1230/drivers/acpi/hardware/hwsleep.c.dist	2009-01-0=
1 17:22:49.000000000 -0500
+++ linux-2.6.28-mmotm1230/drivers/acpi/hardware/hwsleep.c	2009-01-02 05:=
19:05.000000000 -0500
=40=40 -227,8 +227,10 =40=40 acpi_status asmlinkage acpi_enter_sleep_
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 in_value;
+=23ifdef	ACPI_20_GTS_BFS
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
+=23endif
 	acpi_status status;
=20
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
=40=40 -467,8 +469,10 =40=40 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
  ***********************************************************************=
*******/
 acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 =7B
+=23ifdef	ACPI_20_GTS_BFS
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
+=23endif
 	acpi_status status;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;


--==_Exmh_1230891954_3417P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXeuycC3lWbTT17ARApQFAJwMxq8mY0/JkIFbbi5+MO2g+Z9nywCeLZCL
Q56khE1MvzdQ5kdSKnmgnj0=
=5BXq
-----END PGP SIGNATURE-----

--==_Exmh_1230891954_3417P--
