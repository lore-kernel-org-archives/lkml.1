Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYJ3EFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYJ3EFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYJ3EE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:04:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYJ3EE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TyeJRLc7qO44PuKpDI26jrU59b0rjghq2Ygpx93dvSOVtfEMC7KWvOfav4EaoBeyyf
         K8SqvBrGTtjHFC1D9XfRiWs0PRO+hSzXSrs3NIIY69gQ+23rEUVekmRSHkrzDN+nMoIJ
         XdMvKmLrFEa63DorWHBk3mjtyWoAiTdQmqcMY=
Message-ID: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:04:54 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/cpu.c: Section mismatch warning fix.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LD      kernel/built-in.o
WARNING: kernel/built-in.o(.text+0xb7c8): Section mismatch in
reference from the function notify_cpu_starting() to the variable
.cpuinit.data:cpu_chain
The function notify_cpu_starting() references
the variable __cpuinitdata cpu_chain.
This is often because notify_cpu_starting lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

This patch fixes the above section mismatch warning. If anything else
please notice.
Thanks.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/cpu.c	2008-10-28 20:52:38.000000000 +0600
+++ linux-2.6/kernel/cpu.c	2008-10-28 22:46:22.000000000 +0600
@@ -462,7 +462,7 @@ out:
  * It must be called by the arch code on the new cpu, before the new cpu
  * enables interrupts and before the "boot" cpu returns from __cpu_up().
  */
-void notify_cpu_starting(unsigned int cpu)
+void __cpuinit notify_cpu_starting(unsigned int cpu)
 {
 	unsigned long val = CPU_STARTING;
