Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbYBVLaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbYBVLaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYBVLaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:30:10 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:49392 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbYBVLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:30:08 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 06:30:08 EST
Date: Fri, 22 Feb 2008 12:00:24 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH] let XEN depend on PAE
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: xen-devel@lists.xensource.com
Message-id: <47BEAB48.7050900@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,390,1199660400";   d="scan'208";a="51605764"
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As paravirtualized xen guests won't work with !X86_PAE, change the Kconfig
accordingly.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 4d5f264..2035238 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,7 +6,7 @@ config XEN
    bool "Xen guest support"
    select PARAVIRT
    depends on X86_32
-   depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS ||
X86_VOYAGER)
+   depends on X86_PAE && X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES &&
!(X86_VISWS || X86_VOYAGER)
    help
      This is the Linux Xen port.  Enabling this will allow the
      kernel to boot in a paravirtualized environment under the

