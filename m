Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYKZQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYKZQQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYKZQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:16:13 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47148 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKZQQM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:16:12 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Bob Moore <robert.moore@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc6-mmotm1126 - acpi AE_AM_INFINITE_LOOP errors..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227716135_3559P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Nov 2008 11:15:35 -0500
Message-ID: <4018.1227716135@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227716135_3559P
Content-Type: text/plain; charset=us-ascii

I wasn't seeing these in -rc5-1117.
Am suspecting this commit or related:

commit 9c8573ca6e35f327d53cb46aba017b95e05d8e08
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:15:29 2008 +0800

    ACPICA: Add a mechanism to escape infinite AML While() loops

    Add a loop counter to force exit from AML While loops if the
    count becomes too large. This can occur in poorly written AML
    when the hardware does not respond within a while loop and the
    loop does not implement a timeout. The maximum loop count is
    configurable. A new exception code is returned when a loop is
    broken, AE_AML_INFINITE_LOOP.  Bob Moore, Alexey Starikovskiy.

    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

This is a Dell Latitude D820, and didn't seem to have any infinite AML
loops to escape, at least none that I actually hit with previous kernels...

[   14.500963] usb 3-1.2: new full speed USB device using uhci_hcd and address 3
[   14.508930] ACPI Error (psparse-0536): Method parse/execution failed [\SXX6] (Node ffff88007f851a98), AE_AML_INFINITE_LOOP
[   14.508973] ACPI Error (psparse-0536): Method parse/execution failed [\SXX4] (Node ffff88007f851a58), AE_AML_INFINITE_LOOP
[   14.509001] ACPI Error (psparse-0536): Method parse/execution failed [\SX11] (Node ffff88007f8519f8), AE_AML_INFINITE_LOOP
[   14.509029] ACPI Error (psparse-0536): Method parse/execution failed [\_TZ_.THM_.GINF] (Node ffff88007f858858), AE_AML_INFINITE_LOOP
[   14.509058] ACPI Error (psparse-0536): Method parse/execution failed [\_TZ_.THM_._TMP] (Node ffff88007f858878), AE_AML_INFINITE_LOOP
..
[   14.749476] usb 3-1.2: configuration #1 chosen from 1 choice
[   15.589404] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   15.603541] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.LID_._LID] (Node ffff88007f8581f8), AE_AML_INFINITE_LOOP
[   15.617394] ACPI: Lid Switch [LID]
[   15.632375] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input6
[   15.687289] ACPI: Power Button (CM) [PBTN]
[   15.702897] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input7
[   15.737284] ACPI: Sleep Button (CM) [SBTN]
[   16.624380] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   16.638972] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_._DOD] (Node ffff88007f85ded8), AE_AML_INFINITE_LOOP
[   16.654039] ACPI Exception (video-1638): AE_AML_INFINITE_LOOP, Evaluating _DOD [20080926]
[   17.669507] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   17.685120] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_.LCD_._ADR] (Node ffff88007f85dd58), AE_AML_INFINITE_LOOP
[   17.701051] ACPI: Cant attach deviceACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   18.719111] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_.DVI_._ADR] (Node ffff88007f85dcb8), AE_AML_INFINITE_LOOP
[   18.735778] ACPI: Cant attach deviceACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   19.745706] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_._DOS] (Node ffff88007f85def8), AE_AML_INFINITE_LOOP
[   19.763195] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:22/device:23/input/input8
[   19.784055] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   19.893914] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[   20.044222] Real Time Clock Driver v1.12b
[   23.722937] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   23.741371] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   23.759881] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   25.138613] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   25.157545] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   25.176898] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   26.447172] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   26.467212] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   26.487528] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   27.684304] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   27.704947] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   27.725906] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   28.907380] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   28.928958] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   28.950703] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   30.485112] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   30.507460] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   30.530100] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   30.507460] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   30.530100] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   30.701061] Clocksource tsc unstable (delta = -6082993826 ns)
[   32.770589] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   32.793800] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   32.817635] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   33.984725] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   34.008812] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   34.033236] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   35.550289] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   35.574761] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   35.599301] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   36.985099] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   37.009318] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   37.034035] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   38.169534] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[   38.193902] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[   38.218599] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20080926]
[   38.323556] EXT3 FS on dm-0, internal journal


--==_Exmh_1227716135_3559P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJLXYncC3lWbTT17ARAt1fAJ9RJxaDy/bY+Sc2tAv03rq7tl1YpQCfciJv
AuNGSME/AJWxtNXI2dDt12Y=
=EYNK
-----END PGP SIGNATURE-----

--==_Exmh_1227716135_3559P--
