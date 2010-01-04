Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511Ab0ADPHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0ADPHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415Ab0ADPHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:07:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54198 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0ADPHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ACi81eMYFda7izks/t2BhfL27yiUY80taahxz7RS995oWHUko7/PBHxwac++JS0rRt
         5O1wBCLzQsl13U1buE8pARIgKM4BPB7r+huWMhS4HKEN8LbfJ2X39u8a9VV9E+3pMYd3
         VbgdA8saYoZnKItiuzJrfqMM5OnUAM4+R3Sq8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001040954150.29475@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
	 <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
	 <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
	 <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
	 <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>
	 <1820d69d1001040609j6c0b169w38694c33af3fa686@mail.gmail.com>
	 <alpine.DEB.2.00.1001040921000.29475@p34.internal.lan>
	 <1820d69d1001040643h5e2f383bo7e077cbc2d2af554@mail.gmail.com>
	 <alpine.DEB.2.00.1001040954150.29475@p34.internal.lan>
Date: Mon, 4 Jan 2010 16:07:08 +0100
Message-ID: <1820d69d1001040707w69dc5351k3daa035d32dd108a@mail.gmail.com>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
	temp/voltage monitoring)
From: Gabriel C <nix.or.die@googlemail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/4 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
>
> On Mon, 4 Jan 2010, Gabriel C wrote:
>
>> 2010/1/4 Justin Piszcz <jpiszcz@lucidpixels.com>:
>>
>> Anyway It seems like ICH8* has some different output .. can't tell yet
>> without docs =)
>>
>> Please open heci-qst-linux.c and find :
>>
>>
>> const char * const temp_names[THERM_SENSOR_COUNT] = {
>> ...
>>
>> Change to look like this :
>>
>>
>> const char * const temp_names[THERM_SENSOR_COUNT] = {
>>        "CPU  Temp",
>>        "MB1  Temp",
>>         NULL,
>>        "MB2  Temp",
>>        "ICH  Temp",
>>        "MCH  Temp",
>>        NULL,
>>        NULL,
>>        NULL,
>>        NULL,
>>        NULL,
>>        NULL,
>> };
>
> Done:
>
> # ./heci-qst-linux CPU Temp:       34.37   °C
> MB1 Temp:       37.75   °C
> MB2 Temp:       34.89   °C
> ICH Temp:       65.59   °C
> MCH Temp:       46.25   °C
> CPU  Fan:       840     RPM
> INL  Fan:       1398    RPM
> OUTL Fan:       839     RPM
> AUX  Fan:       2607    RPM
> +12  Volts:     12.040  V
> +5   Volts:     4.954   V
> +3.3 Volts:     3.247   V
> MCH  Vccp:      1.258   V
> CPU1 Vccp:      1.165   V
>


Ok that looks now right for your HW.

>> Also can you post a lspci -nn please :)
>
> # lspci -nn
> 00:00.0 Host bridge [0600]: Intel Corporation 82P965/G965 Memory Controller
> Hub [8086:29a0] (rev 02)
> 00:01.0 PCI bridge [0604]: Intel Corporation 82P965/G965 PCI Express Root
> Port [8086:29a1] (rev 02)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G965
> Integrated Graphics Controller [8086:29a2] (rev 02)
> 00:03.0 Communication controller [0780]: Intel Corporation 82P965/G965 HECI
> Controller [8086:29a4] (rev 02)
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82566DC Gigabit
> Network Connection [8086:104b] (rev 02)
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #4 [8086:2834] (rev 02)
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #5 [8086:2835] (rev 02)
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2
> EHCI Controller #2 [8086:283a] (rev 02)
> 00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audio
> Controller [8086:284b] (rev 02)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
> Express Port 1 [8086:283f] (rev 02)
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
> Express Port 2 [8086:2841] (rev 02)
> 00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
> Express Port 3 [8086:2843] (rev 02)
> 00:1c.3 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
> Express Port 4 [8086:2845] (rev 02)
> 00:1c.4 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
> Express Port 5 [8086:2847] (rev 02)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #1 [8086:2830] (rev 02)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #2 [8086:2831] (rev 02)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #3 [8086:2832] (rev 02)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2
> EHCI Controller #1 [8086:2836] (rev 02)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e]
> (rev f2)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801HH (ICH8DH) LPC Interface
> Controller [8086:2812] (rev 02)
> 00:1f.2 SATA controller [0106]: Intel Corporation 82801HR/HO/HH
> (ICH8R/DO/DH) 6 port SATA AHCI Controller [8086:2821] (rev 02)
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus
> Controller [8086:283e] (rev 02)
> 01:00.0 SCSI storage controller [0100]: Marvell Technology Group Ltd.
> 88SX7042 PCI-e 4-port SATA-II [11ab:7042] (rev 02)
> 03:00.0 IDE interface [0101]: Marvell Technology Group Ltd. 88SE6101
> single-port PATA133 interface [11ab:6101] (rev b1)
> 04:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA
> Raid II Controller [1095:3132] (rev 01)
> 05:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA
> Raid II Controller [1095:3132] (rev 01)
> 06:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA
> Raid II Controller [1095:3132] (rev 01)
> 07:00.0 Ethernet controller [0200]: Intel Corporation 82540EM Gigabit
> Ethernet Controller [8086:100e] (rev 02)
> 07:01.0 Ethernet controller [0200]: Intel Corporation 82541GI Gigabit
> Ethernet Controller [8086:1076]
> 07:02.0 Mass storage controller [0180]: Promise Technology, Inc. PDC40718
> (SATA 300 TX4) [105a:3d17] (rev 02)
> 07:03.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link) [104c:8023]
>

Thx :)

> Justin.
>

Gabriel
