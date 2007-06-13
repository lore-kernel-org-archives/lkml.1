Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbXFMIRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbXFMIRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXFMIRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:17:06 -0400
Received: from queue04-winn.ispmail.ntl.com ([81.103.221.58]:65482 "EHLO
	queue04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbXFMIRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:17:04 -0400
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 04:17:04 EDT
Subject: DRI/AGP on AMD64 based machine
From: Alex Bennee <kernel-hacker@bennee.com>
Reply-To: kernel-hacker@bennee.com
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 09:02:15 +0100
Message-Id: <1181721735.4418.10.camel@malory>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a while now I've been meaning to get DRI running with my rv350
graphics card on my AMD64 machine. However I don't seem to be able to
get the right config-fu in the kernel to enable all the components.

For my sins I've been following the Gentoo Howto Wiki
(http://gentoo-wiki.com/HOWTO_DRI_with_ATi_Open-Source_Drivers)

A lot of the AGP stuff in the Kernel seems to be locked to 32 bit
kernels. The instructions seem to imply there is an am64-agp module
(which looks as though it builds in the tree but doesn't install) and
possibly an nvidea-agp module. I'm a little confused as I have both AMD
and NVidia chipsets on my machine:

malory agp # lspci             
00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev
a1)
00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management
(rev a1)
00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0
Controller (rev a2)
00:05.0 Bridge: nVidia Corporation CK8S Ethernet Controller (rev a2)
00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb
AC'97 Audio Controller (rev a1)
00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller
(v2.5) (rev a2)
00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller
(v2.5) (rev a2)
00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI
Bridge (rev a2)
00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge
(rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AS [Radeon
9550]
01:00.1 Display controller: ATI Technologies Inc RV350 AS [Radeon 9550]
(Secondary)
02:06.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
02:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)

Any clues on the correct AGP config options to switch on gratefully
received. My current .config looks like:

08:56 alex@malory [linux-2.6-stable.git] >grep "AGP" .config
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=m

08:59 alex@malory [linux-2.6-stable.git] >grep "DRM" .config
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set

Regards,


--
Alex, homepage: http://www.bennee.com/~alex/
Television has brought back murder into the home -- where it belongs. --
Alfred Hitchcock

