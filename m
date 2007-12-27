Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXL0RPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXL0RPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXL0RPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:15:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54563 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXL0RPV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:15:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc6-mm1 - power_supply driver dmesg weirdness?
In-Reply-To: Your message of "Sat, 22 Dec 2007 23:30:56 PST."
             <20071222233056.d652743e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198747013_3270P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Dec 2007 04:16:53 -0500
Message-ID: <4081.1198747013@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198747013_3270P
Content-Type: text/plain; charset=us-ascii

On Sat, 22 Dec 2007 23:30:56 PST, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/

Happened to be looking more closely than usual at my dmesg looking for something
else, and spotted this:

[    6.079043] power_supply BAT0: 11 dynamic props
[    6.079045] power_supply BAT0: prop STATUS=Full
[    6.079047] power_supply BAT0: prop PRESENT=1
[    6.079049] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    6.079052] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    6.079054] power_supply BAT0: prop VOLTAGE_NOW=11793000
[    6.079056] power_supply BAT0: prop CURRENT_NOW=1000
[    6.079058] power_supply BAT0: prop CHARGE_FULL_DESIGN=7800000
[    6.079061] power_supply BAT0: prop CHARGE_FULL=3110000
[    6.079063] power_supply BAT0: prop CHARGE_NOW=7800000
[    6.079065] power_supply BAT0: prop TIME_TO_FULL_AVG=DELL FF2316
[    6.079067] power_supply BAT0: prop MODEL_NAME=Sanyo
[    6.079301] ACPI: SSDT 7FE82138, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    6.079488] ACPI: SSDT 7FE81EED, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)

What's with that TIME_TO_FULL_AVG value?  Is the battery on crack, or my BIOS,
or the driver?  I expected time units, not a Dell part number ;) (Yes, I know
CHARGE_FULL is low, the battery is pretty beat, and  Latitudes seem to always
report CHARGE_NOW as "design full" when running off the AC power brick)

(For the record, dmidecode says:

Handle 0x1600, DMI type 22, 26 bytes
Portable Battery
        Location: Sys. Battery Bay
        Manufacturer: Sanyo           
        Name: DELL FF2316A    
        Design Capacity: 78000 mWh
        Design Voltage: 11100 mV
        SBDS Version: 1.0
        Maximum Error: 0%
        SBDS Serial Number: 0355
        SBDS Manufacture Date: 2006-10-26
        SBDS Chemistry: LION            
        OEM-specific Information: 0x00000001

So it even managed to lose the trailing 'A'.. ;)

--==_Exmh_1198747013_3270P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHc22FcC3lWbTT17ARArgTAKCxsl+N98s1fiVWraPd6UykUZGzRQCfVHci
yM1ypZMT/UPqJPBg7SXj788=
=XTVp
-----END PGP SIGNATURE-----

--==_Exmh_1198747013_3270P--
