Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbXI0PLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbXI0PLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXI0PLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:11:16 -0400
Received: from SOKENS03e.snapon.com ([217.33.151.228]:37607 "EHLO
	sokens03.snapon.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752790AbXI0PLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:11:16 -0400
X-Greylist: delayed 1543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 11:11:15 EDT
Message-ID: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
From: "Marco Tralli" <marco.tralli@snapon.com>
To: "Jordan Crouse" <jordan.crouse@amd.com>, <linux-kernel@vger.kernel.org>
Subject: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 16:44:22 +0200
Organization: SNAPON
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1807
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
X-OriginalArrivalTime: 27 Sep 2007 14:45:30.0157 (UTC) FILETIME=[0CD955D0:01C80115]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have random hangs on kernel boot or after few minutes on a NatSemi Geode
GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system locks,
no way to use SysRq key, no usefull logs.

No problems using kernel 2.6.21 series that I was using before with same
config options.

I found that commenting out "geode_configure" call in
arch/i386/kernel/cpu/cyrix.c the problem is fixed.

I guess recent changes to cyrix.c that replace macros setCx86/getCx86 with
inlined functions have now "activate" performance tricks in geode_configure
code that previously were "inactive" due to wrong macro espansion. So not
only "Suspend on Halt" function is enabled but also less or not documented
geode tricks (incrementor margin, fast fpu, write-back) now broken on some
GX1/GXm platform (maybe because of BIOS?)

I can further investigate on what exact geode_configure part cause my hangs,
but I suggest to make a config options to explicity enable Geode performance
tricks only if requested (maybe using CONFIG_MGEODEGX1) .

Regards
Marco Tralli
Snap-on Equipment


processor : 0
vendor_id : CyrixInstead
cpu family : 5
model  : 9
model name : Geode(TM) Integrated Processor by National Semi
stepping : 2
cpu MHz  : 299.239
cache size : 16 KB
fdiv_bug : no
hlt_bug  : no
f00f_bug : no
coma_bug : no
fpu  : yes
fpu_exception : yes
cpuid level : 2
wp  : yes
flags  : fpu tsc msr cx8 cmov mmx cxmmx
bogomips : 596.37

