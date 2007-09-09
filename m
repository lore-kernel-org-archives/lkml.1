Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbXIINT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbXIINT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 09:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXIINTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 09:19:22 -0400
Received: from mail96.megamailservers.com ([216.251.36.96]:42044 "EHLO
	mail96.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104AbXIINTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 09:19:21 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: [PATCH] KCONFIG: fix pseudo dependency between K8_NUMA and
	X86_64_ACPI_NUMA config options
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p734pi4rytz.fsf@bingen.suse.de>
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
	 <1189300961.13467.47.camel@Tachyon.home>  <p734pi4rytz.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sun, 09 Sep 2007 09:19:05 -0400
Message-Id: <1189343945.7365.9.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-09 at 11:07 +0200, Andi Kleen wrote:
> "James C. Georgas" <jgeorgas@georgas.ca> writes:
> > 
> > It's 2.6.22.6. I'm thinking a fix would be to add "select PM" to
> > X86_64_ACPI_NUMA.
> > 
> > I'm also thinking that maybe K8_NUMA should be changed from "depends on
> > PCI" to "select PCI", like X86_64_ACPI_NUMA is. That would fix the
> > pseudo dependency they have between them (i.e. selecting
> > X86_64_ACPI_NUMA causes PCI to be selected, which then makes K8_NUMA
> > visible, because its PCI dependency is now satisfied).
> 
> Sounds reasonable. Can you please submit a tested patch with proper
> description and Signed-off-by lines?
> 
> -Andi

How's this?


>From 6febbd64aaca5d54487d8f9df4949001e0fc4ec6 Mon Sep 17 00:00:00 2001
From: James C. Georgas <jgeorgas@georgas.ca>
Date: Sun, 9 Sep 2007 08:27:46 -0400
Subject: [PATCH] Signed-off-by: James C. Georgas <jgeorgas@georgas.ca>

Changed K8_NUMA from "depends on PCI" to "select PCI", like X86_64_ACPI_NUMA is. This fixes the pseudo dependency between X86_64_ACPI_NUMA and K8_NUMA (i.e. selecting X86_64_ACPI_NUMA would cause PCI to be selected, which then made K8_NUMA visible, because its PCI dependency was now satisfied).
---
 arch/x86_64/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index ffa0364..bdeeb25 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -357,7 +357,8 @@ config NUMA
 
 config K8_NUMA
        bool "Old style AMD Opteron NUMA detection"
-       depends on NUMA && PCI
+       depends on NUMA
+       select PCI
        default y
        help
         Enable K8 NUMA node topology detection.  You should say Y here if
-- 
1.5.1.6


