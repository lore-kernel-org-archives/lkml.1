Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYJRCSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYJRCSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYJRCSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:18:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50797 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJRCSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=h6B1BjLPLFehyMDDaF3BFJMrxL1hVY2tELkTujHPntG+0CNtMVAaMWSlbfhowFO3Va
         4ECxAbJouSNsXZn9kPfE3xJQPW1NSBNx2nYeqFmGcHSY9kuPb8Hwqr0KEgE0vAZFpuq8
         uRBi0RUCdtlm8WeNdn8RCyaQ0LJDoWBXz+TY8=
Message-ID: <b9df5fa10810171917n31fc38a4j4805a38df2e83f51@mail.gmail.com>
Date: Sat, 18 Oct 2008 08:17:58 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kvmclock.c: Fix section mismatch warning.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.text+0x1722c): Section mismatch
in reference from the function kvm_setup_secondary_clock() to the
function .devinit.text:setup_secondary_APIC_clock()
The function kvm_setup_secondary_clock() references
the function __devinit setup_secondary_APIC_clock().
This is often because kvm_setup_secondary_clock lacks a __devinit
annotation or the annotation of setup_secondary_APIC_clock is wrong.

This patch fixes the above warning.
Thanks.

Signed-off-by: Md.Rakib H. Mullick(rakib.mullick@gmail.com)

--- linux-2.6-orig/arch/x86/kernel/kvmclock.c	2008-10-16
20:03:12.000000000 +0600
+++ linux-2.6/arch/x86/kernel/kvmclock.c	2008-10-17 23:48:54.000000000 +0600
@@ -100,7 +100,7 @@ static int kvm_register_clock(char *txt)
 }

 #ifdef CONFIG_X86_LOCAL_APIC
-static void kvm_setup_secondary_clock(void)
+static void __devinit kvm_setup_secondary_clock(void)
 {
 	/*
 	 * Now that the first cpu already had this clocksource initialized,
