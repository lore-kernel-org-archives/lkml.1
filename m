Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYAQMg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYAQMg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAQMgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:36:18 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:45748 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYAQMgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:36:17 -0500
Date: Thu, 17 Jan 2008 13:36:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Enable PAT for more AMD CPUs
Message-ID: <20080117123613.GA22563@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 17 Jan 2008 12:30:01.0814 (UTC) FILETIME=[AE3E9F60:01C85904]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I checked some K7 errata files and couldn't find anything related
to PAT.  Also for Fam10h and 11h it should be definitely enabled.

Enable PAT for all AMD CPUs >= 6, which is K7 and newer.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/mm/pat.c
===================================================================
--- linux.orig/arch/x86/mm/pat.c
+++ linux/arch/x86/mm/pat.c
@@ -49,7 +49,7 @@ static int pat_known_cpu(void)
 		return cpu_has_pat;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-					    (boot_cpu_data.x86 == 0xF))
+					    (boot_cpu_data.x86 >= 6))
 		return cpu_has_pat;
 
 	return 0;
