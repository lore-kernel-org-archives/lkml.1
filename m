Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbZEMRLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbZEMRLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbZEMRLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:11:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZEMRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:11:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] arm: rename CLOCK_TICK_RATE to ARM_TICK_RATE
Date: Wed, 13 May 2009 19:11:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090511222702.352192505@arndb.de> <20090511222702.352192505@arndb.de>> <200905112243.10011.arnd@arndb.de>
In-Reply-To: <200905112243.10011.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905131911.23473.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+cHPymSI+aPbertyNdulG6NIdKkKm6d3XGFPz
 ZvhgrtDwcp4HztbCzV6bvcfOH9VyCFr0qjxYM+yY8bxQe3POH0
 lgni3BCIUByyiJthTiLCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Arnd Bergmann wrote:
> Most of the users of CLOCK_TICK_RATE in the kernel outside
> of ARM assume that it refers to the i8253 base frequency
> of 1.193182 Mhz, while in ARM it actually is the clock
> frequency of the timer.
> 
> By renaming it to ARM_TICK_RATE for all arm specific
> device drivers, we can hopefully reduce the amount
> of confusion slightly.

My patch was missing one important change to make this
a nonintrusive change:

--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -14,6 +14,8 @@
 
 #include <mach/timex.h>
 
+#define CLOCK_TICK_RATE ARM_TICK_RATE
+
 typedef unsigned long cycles_t;
 
 static inline cycles_t get_cycles (void)

	Arnd <><
