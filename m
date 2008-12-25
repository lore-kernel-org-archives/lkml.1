Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbYLYMSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbYLYMSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYLYMRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:17:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:49114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYLYMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:17:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MIB6Ug9eYG2VIKkL15ODCuJmIN1Q592p4IVAchUExkEA+YqLhM8wxEfi6MbpaIeol3
         qBfU38/1Sj/IjqW48lbJFpZGbp9H9PHkOiifgmIti8nXo9xdmBG3ry4gCPQyQMJhalWi
         sovCCk4Gv3g+PwTvFydMi+yDfAz0auftXY4Wo=
Message-ID: <c43b2e150812250417n367d0910gea4b7d3162948cf6@mail.gmail.com>
Date: Thu, 25 Dec 2008 13:17:49 +0100
From: wixor <wixorpeek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: HPET not working with VT8237A
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have Fujitsu-Siemens Amilo Pro v3515 laptop. lspci -nn says:

00:00.0 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:0364]
00:00.1 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:1364]
00:00.2 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:2364]
00:00.3 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:3364]
00:00.4 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:4364]
00:00.5 PIC [0800]: VIA Technologies, Inc. CN896/VN896/P4M900 I/O APIC
Interrupt Controller [1106:5364]
00:00.6 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Security Device [1106:6364]
00:00.7 Host bridge [0600]: VIA Technologies, Inc. CN896/VN896/P4M900
Host Bridge [1106:7364]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8237/VX700 PCI
Bridge [1106:b198]
00:02.0 PCI bridge [0604]: VIA Technologies, Inc. CN896/VN896/P4M900
PCI to PCI Bridge Controller [1106:a364] (rev 80)
00:03.0 PCI bridge [0604]: VIA Technologies, Inc. CN896/VN896/P4M900
PCI to PCI Bridge Controller [1106:c364] (rev 80)
00:0f.0 IDE interface [0101]: VIA Technologies, Inc. VT8237A SATA
2-Port Controller [1106:0591] (rev 80)
00:0f.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
(rev 07)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev a0)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev a0)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev a0)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev a0)
00:10.4 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
[1106:3104] (rev 86)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8237A PCI to ISA
Bridge [1106:3337]
00:11.7 Host bridge [0600]: VIA Technologies, Inc. VT8251 Ultra VLINK
Controller [1106:287e]
00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102
[Rhine-II] [1106:3065] (rev 7c)
00:13.0 PCI bridge [0604]: VIA Technologies, Inc. VT8237A Host Bridge
[1106:337b]
00:13.1 PCI bridge [0604]: VIA Technologies, Inc. VT8237A PCI to PCI
Bridge [1106:337a]
01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc.
CN896/VN896/P4M900 [Chrome 9 HC] [1106:3371] (rev 01)
04:01.0 Audio device [0403]: VIA Technologies, Inc. VT1708/A [Azalia
HDAC] (VIA High Definition Audio Controller) [1106:3288] (rev 10)
05:01.0 Ethernet controller [0200]: Atheros Communications Inc. AR2413
802.11bg NIC [168c:001a] (rev 01)

lspci -d 1106:3337 -xxx says:

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
00: 06 11 37 33 03 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 34 17 cb 10
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 80 f0 0b 00 a0 10 00 0c 20 00 00 44 00 08 00
50: 80 18 09 00 00 00 00 00 62 90 00 03 00 60 00 fe
60: 68 00 00 00 01 07 07 45 00 00 00 00 00 00 00 00
70: 34 17 cb 10 00 00 00 00 00 00 00 00 00 00 00 00
80: 20 86 5a 00 da 40 00 00 01 40 00 00 05 08 00 00
90: 00 cd 9e 00 20 cd 04 42 00 08 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 41 01 00 34 17 00 00 00 00 00 00 00 00 00 00
e0: 08 00 0e 00 e0 01 ef 82 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 13 00 00 00 00 00 00 00 00 00

HPET is not detected neither normally nor with hpet=force option. I looked
up kernel source and found out, that there are no quirks for this chip.

HPET is not advertised by HPET acpi table, but I found it in DSDT table as
device PNP0103. However, looking in /sys/bus/acpi/devices reveals that
kernel is unaware of it. Anyway, DSDT reports, that HPET should be living
at 0xFED04000. I am completely unable to google any via spec of this chip.

I would be very glad to see it running. Any way to enable it?
Please CC me, I'm not in the list.

--
wixor
