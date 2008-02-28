Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbYB1Q3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbYB1Q3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbYB1Q3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:29:07 -0500
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:5344 "EHLO
	wipro-blr-out01.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbYB1Q3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:29:05 -0500
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 11:29:05 EST
X-AuditID: cb5bdd57-aa730bb000000741-c2-47c6e9413819
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Wrong IRQ assigned on MPC8349EMDS board
Date: Thu, 28 Feb 2008 21:38:36 +0530
Message-ID: <4F36B0A4CDAD6F46A61B2B32C33DC69C05C579C0@BLR-EC-MBX03.wipro.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Wrong IRQ assigned on MPC8349EMDS board
Thread-Index: Ach6JCyQFcb6EASnQ8ehC43Eoit3Gg==
From: <biswa.nayak@wipro.com>
To: <linuxppc-dev@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Feb 2008 16:08:30.0358 (UTC) FILETIME=[28E53360:01C87A24]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list
I am trying to bring up MPC8349EMDS board with linux-2.6.18 kernel with
ramfs enabled.
I am passing a device tree binary (dtb) compiled from the corresponding
dts file found from the 'arch/powerpc/boot/dts' directory and compiled
with the device tree compiler.
 
I found that the IRQ lines assigned to different peripherals are
completely wrong.
My serial ports are connected to pin 9 and 10, but in this kernel the
IRQs assigned are 16 and 17. 

On a little investigation I found that the base address assigned to the
IPIC chip is '0xFDDFB700'

If I compile the linux version with 'ARCH=ppc' and boot then my IPIC
base address
is getting assigned as 0xFE000700, which I think is the correct
behaviour. 

I checked in the dts file and found that the IPIC offset is mentioned as
700 and size as 100,
which are correct as per the manual. 
Even the IRQ lines mentioned for the Serial ports in the DTS are '9' and
'A'.

Does this wrong assignment is due to the wrong base address of the IPIC
chip?
With IRQs 16 and 17, how the serial console is working fine?

When I tried hard coding the IPIC base value to '0xfe000700' then the
system refuses to boot up.

I kept the IPIC base as 0xfddfb700 and hard coded the irq lines for
serial ports as 9 and 10
and in that case the 'request_irq' call fails with the error number as
'-38',
which translates to '-ENOSYS'. 

The changes in the dts never gets reflected in the kernel, 
no matter what lines I set for serial line in the dts, the request
always goes for line 16 and 17.

Please let me know if you need any more information regarding the same.
Any help in this will be highly appreciated.

Thanks
Biswa
