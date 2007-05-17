Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXEQAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXEQAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXEQAJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:09:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXEQAJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:09:19 -0400
Message-ID: <464B9D2C.7040704@cv-sv.de>
Date: Thu, 17 May 2007 02:09:16 +0200
From: Christian <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX189j+mM0IaZ3E8eHbMNim/0bHhpxdYt6P+EBjM
 fxykVnEKyKxQ3BZCNinW7tDbu1p7A3WlIkeVP9s3DRDW/UerP6
 uCTNlDjzzkmlnVvkVC49w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my small VIA C3_2 box does not boot with 2.6.22-rc1.
It even does not uncompress the kernel.

The configuration as M386 M486 works. But M586 + MVIAC3_2
does not work.

solution for me, cahnge arch/i386/Kconfig.cpu

--- arch/i386/Kconfig.cpu.before     2007-05-17 01:38:26.000000000 +0200
+++ arch/i386/Kconfig.cpu       2007-05-17 00:54:52.000000000 +0200
@@ -299,5 +299,5 @@

 config X86_CMPXCHG64
        bool
-       depends on !M386 && !M486
+       depends on !M386 && !M486 && !MVIAC3_2
        default y


The related #ifdef is in ./include/asm-i386/cmpxchg.h
May be cmpxchg8b is not supported by VIAC3_2 ?

May be some other non Intel/AMD need to be excluded from X86_CMPXCHG64 ?
May be the generic option CONFIG_X86_GENERIC need to switch this off also ?


Just write an email to me if you want to send a patch to test on a C3_2.

Best regards,

Christian


