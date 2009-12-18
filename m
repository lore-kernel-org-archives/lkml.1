Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZLRL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZLRL4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZLRL4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:56:37 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3994 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZLRL4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:56:36 -0500
X-SpamScore: -34
X-BigFish: VPS-34(z21eWz1432R98dN148cMa84eizz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUUJTZ-01-1GT-02
X-M-MSG: 
Date: Fri, 18 Dec 2009 12:56:39 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error
 with linux-2.6.32)
Message-ID: <20091218115639.GA28439@aftab>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912170407.04568.johannes.hirte@fem.tu-ilmenau.de>
 <20091217072232.GB4293@aftab>
 <200912172003.30023.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200912172003.30023.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Dec 2009 11:56:23.0391 (UTC) FILETIME=[1EBE76F0:01CA7FD9]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:03:29PM +0100, Johannes Hirte wrote:
> GART Error Reporting was disabled. Here is the output after enabling it:
>
> datengrab ~ # lsmsr MC4 -V3
> MC4_CTL              = 0x0000000000003bff
>   CorrEccEn=0x1
>   UnCorrEccEn=0x1
>   CrcErr0En=0x1
>   CrcErr1En=0x1
>   CrcErr2En=0x1
>   SyncPkt0En=0x1
>   SyncPkt1En=0x1
>   SyncPkt2En=0x1
>   MstrAbrtEn=0x1
>   TgtAbrtEn=0x1
>   GartTblWkEn=0
>   AtomicRMWEn=0x1
>   WchDogTmrEn=0x1
>   DramParEn=0

[.. ]

> MC4_CTL_MASK         = 0x0000000000000000
>   CorrEccEn=0
>   UnCorrEccEn=0
>   CrcErr0En=0
>   CrcErr1En=0
>   CrcErr2En=0
>   SyncPkt0En=0
>   SyncPkt1En=0
>   SyncPkt2En=0
>   MstrAbrtEn=0
>   TgtAbrtEn=0
>   GartTblWkEn=0

Ok, thanks for testing. It looks like your BIOS is applying the wrong
workaround when the option is enabled. It clears MC4_CTL[GartTblWkEn],
which means, it disables reporting of GART table walk errors while
they're still being logged by the hw. What it should do is to set
MC4_CTL_MASK[GartTblWkEn] to 1 so that logging gets disabled, as it is
recommended in the K8 BKDG.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

