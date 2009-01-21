Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZAUP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZAUP5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZAUP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:57:27 -0500
Received: from mail91.analogic.com ([12.187.86.31]:49422 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195AbZAUP51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:57:27 -0500
X-AuditID: 0a770115-a9afebb000000e5e-8e-497745e522d3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Jan 2009 15:57:25.0680 (UTC) FILETIME=[F4356300:01C97BE0]
Content-class: urn:content-classes:message
Subject: Getting out-of-kernel modules compiled
Date: Wed, 21 Jan 2009 10:57:25 -0500
Message-ID: <Pine.LNX.4.61.0901211052020.16591@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Getting out-of-kernel modules compiled
Thread-Index: Acl74PQ+VlfjpIndSkGNuxaA2Oe/EQ==
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Back in 2004, we make the following to compile
out-of-kernel modules. It worked.

Now, the kernel build doesn't "know" how to handle "asm.S"
files and always thinks a "name.o" file is the result of
a "name.c" file, so I can't buld them no  matter how hard
I try!

What do I need to do????

#
#	Project Makefile for kernel versions over 6 
#	Created 05-OCT-2004	Richard B. Johnson
#

VER	:=	$(shell uname -r)
PWD	:=	$(shell pwd)

all:		driver

driver:
 		make V=1 -C /usr/src/linux-$(VER) SUBDIRS=$(PWD) modules

rtc_hwr.o:	rtc_hwr.S
 		as -o $@ $<

obj-m		= 	rtc.o
obj-m		+= 	rtc_hwr.o

clean:
 		rm -rf *.o *.ko *.mod.c \.*.cmd

make[2]: *** No rule to make target `/root/BCS/rtc/rtc_hwr.c', needed by `/root/BCS/rtc/rtc_hwr.o'.  Stop.
make[1]: *** [_module_/root/BCS/rtc] Error 2
make: *** [driver] Error 2


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4784.32 BogoMips).
My book : http://www.AbominableFirebug.com/
.


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
