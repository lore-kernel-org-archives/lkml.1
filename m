Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYGGWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYGGWJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYGGWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:09:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbYGGWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:09:32 -0400
Message-ID: <48729418.4000206@firstfloor.org>
Date: Tue, 08 Jul 2008 00:09:28 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
References: <200807041120.678642023@firstfloor.org> <48728A0E.7010802@kernel.org>
In-Reply-To: <48728A0E.7010802@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------080101060301080904080604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080101060301080904080604
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> This patchkit uses the 64bit machine check code which is better in many
>> ways on 32bit x86 too. This is also the basis for some future machine
>> check work.
> 
> Hi Andi,
> 
> I tried applying your patch kit to -tip, but I'm getting build failures
> on i386; gcc-4.1.1-51.fc5.x86_64 with attached configuration.

Thanks for testing.

Your config seems to for some reason not do an implicit asm/apic.h
that the file relied on.

With this additional patch applied before the final unification
your config builds.

Also fixed the strtoull warnings.

I'm sending a new patch series.

-Andi




--------------080101060301080904080604
Content-Type: text/plain;
 name="include"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="include"

Add missing includes in mce_intel_64.c

In some i386 configurations these are not implicitely included.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -12,6 +12,8 @@
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
+#include <asm/apic.h>
+#include <asm/pda.h>
 
 asmlinkage void smp_thermal_interrupt(void)
 {

--------------080101060301080904080604--
