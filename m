Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429Ab0ADOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0ADOzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122Ab0ADOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:55:44 -0500
Received: from lucidpixels.com ([75.144.35.66]:38580 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0ADOzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:55:43 -0500
Date: Mon, 4 Jan 2010 09:55:42 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
 temp/voltage monitoring)
In-Reply-To: <1820d69d1001040643h5e2f383bo7e077cbc2d2af554@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001040954150.29475@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>  <4964DB3E.6080908@intel.com>  <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>  <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>  <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
  <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>  <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>  <1820d69d1001040609j6c0b169w38694c33af3fa686@mail.gmail.com>  <alpine.DEB.2.00.1001040921000.29475@p34.internal.lan>
 <1820d69d1001040643h5e2f383bo7e077cbc2d2af554@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1383000122-1262616942=:29475"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1383000122-1262616942=:29475
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 4 Jan 2010, Gabriel C wrote:

> 2010/1/4 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
> Anyway It seems like ICH8* has some different output .. can't tell yet
> without docs =3D)
>
> Please open heci-qst-linux.c and find :
>
>
> const char * const temp_names[THERM_SENSOR_COUNT] =3D {
> ...
>
> Change to look like this :
>
>
> const char * const temp_names[THERM_SENSOR_COUNT] =3D {
> =A0 =A0 =A0 =A0"CPU =A0Temp",
> =A0 =A0 =A0 =A0"MB1 =A0Temp",
> =A0 =A0 =A0 =A0 NULL,
> =A0 =A0 =A0 =A0"MB2 =A0Temp",
> =A0 =A0 =A0 =A0"ICH =A0Temp",
> =A0 =A0 =A0 =A0"MCH =A0Temp",
> =A0 =A0 =A0 =A0NULL,
> =A0 =A0 =A0 =A0NULL,
> =A0 =A0 =A0 =A0NULL,
> =A0 =A0 =A0 =A0NULL,
> =A0 =A0 =A0 =A0NULL,
> =A0 =A0 =A0 =A0NULL,
> };

Done:

# ./heci-qst-linux=20
CPU Temp:       34.37   =B0C
MB1 Temp:       37.75   =B0C
MB2 Temp:       34.89   =B0C
ICH Temp:       65.59   =B0C
MCH Temp:       46.25   =B0C
CPU  Fan:       840     RPM
INL  Fan:       1398    RPM
OUTL Fan:       839     RPM
AUX  Fan:       2607    RPM
+12  Volts:     12.040  V
+5   Volts:     4.954   V
+3.3 Volts:     3.247   V
MCH  Vccp:      1.258   V
CPU1 Vccp:      1.165   V

> Also can you post a lspci -nn please :)
# lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 82P965/G965 Memory Controller=
 Hub [8086:29a0] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 82P965/G965 PCI Express Root P=
ort [8086:29a1] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G965 Integrat=
ed Graphics Controller [8086:29a2] (rev 02)
00:03.0 Communication controller [0780]: Intel Corporation 82P965/G965 HECI=
 Controller [8086:29a4] (rev 02)
00:19.0 Ethernet controller [0200]: Intel Corporation 82566DC Gigabit Netwo=
rk Connection [8086:104b] (rev 02)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB U=
HCI Controller #4 [8086:2834] (rev 02)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB U=
HCI Controller #5 [8086:2835] (rev 02)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 =
EHCI Controller #2 [8086:283a] (rev 02)
00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audi=
o Controller [8086:284b] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Expre=
ss Port 1 [8086:283f] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Expre=
ss Port 2 [8086:2841] (rev 02)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Expre=
ss Port 3 [8086:2843] (rev 02)
00:1c.3 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Expre=
ss Port 4 [8086:2845] (rev 02)
00:1c.4 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Expre=
ss Port 5 [8086:2847] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB U=
HCI Controller #1 [8086:2830] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB U=
HCI Controller #2 [8086:2831] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB U=
HCI Controller #3 [8086:2832] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 =
EHCI Controller #1 [8086:2836] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (=
rev f2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801HH (ICH8DH) LPC Interface=
 Controller [8086:2812] (rev 02)
00:1f.2 SATA controller [0106]: Intel Corporation 82801HR/HO/HH (ICH8R/DO/D=
H) 6 port SATA AHCI Controller [8086:2821] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus Controll=
er [8086:283e] (rev 02)
01:00.0 SCSI storage controller [0100]: Marvell Technology Group Ltd. 88SX7=
042 PCI-e 4-port SATA-II [11ab:7042] (rev 02)
03:00.0 IDE interface [0101]: Marvell Technology Group Ltd. 88SE6101 single=
-port PATA133 interface [11ab:6101] (rev b1)
04:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA=
 Raid II Controller [1095:3132] (rev 01)
05:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA=
 Raid II Controller [1095:3132] (rev 01)
06:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA=
 Raid II Controller [1095:3132] (rev 01)
07:00.0 Ethernet controller [0200]: Intel Corporation 82540EM Gigabit Ether=
net Controller [8086:100e] (rev 02)
07:01.0 Ethernet controller [0200]: Intel Corporation 82541GI Gigabit Ether=
net Controller [8086:1076]
07:02.0 Mass storage controller [0180]: Promise Technology, Inc. PDC40718 (=
SATA 300 TX4) [105a:3d17] (rev 02)
07:03.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB22/A IEEE-139=
4a-2000 Controller (PHY/Link) [104c:8023]

Justin.

---1463747160-1383000122-1262616942=:29475--
