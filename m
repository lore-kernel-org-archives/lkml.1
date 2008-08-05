Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYHEU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYHEU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYHEU0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:26:40 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:40235 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbYHEU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:26:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: 2.6.27-rc1-mm1: unable to boot with gcov on x86_64
Date: Tue, 5 Aug 2008 22:26:36 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
In-Reply-To: <20080731000354.24b55d5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808052226.36626.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

	I'm seeing similar GCOV problems as with 2.6.26-rc5-mm1 that you fixed.
This is the same x86_64 box and again it was unable to boot with gcov enabled.
A quick look revealed that arch/x86/tsc_64.c and arch/x86/tsc_32.c code was
unified. Unfortunately simple change of

GCOV_tsc_32.o := n
GCOV_tsc_64.o := n

to

GCOV_tsc.o := n

did not help. Given the amount of combinations of which set of files with GCOV
might cause failures I was rather fortunate and after a few hours I was able
to pinpoint exactly two files which need GCOV disabled to make my x86_64 boot.

If you want to try to figure out what is wrong with them please feel free to send
me patches to test. If not then how about this patch? Compile and run tested.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- linux-2.6.27-rc1-mm1/arch/x86/kernel/Makefile	2008-08-01 18:05:04.000000000 +0200
+++ linux-2.6.27-rc1-mm1-dirty/arch/x86/kernel/Makefile	2008-08-05 21:49:21.000000000 +0200
@@ -13,8 +13,8 @@ CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt.o = -pg
 endif
 
-GCOV_tsc_32.o := n
-GCOV_tsc_64.o := n
+GCOV_vsyscall_64.o := n
+GCOV_tsc.o := n
 
 #
 # vsyscalls (which work on the user stack) should have


	Mariusz
