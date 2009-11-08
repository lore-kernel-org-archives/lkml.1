Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZKHPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZKHPxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKHPxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:53:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:27984 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZKHPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VA8pT98WhzbIfYzX5GeoiRCuYmKp+nngna3WoMpVzVmH55y68I5xHgd78VUgfR/ajd
         2tPZ+HMcc2BNx5rg/gx/4wMRoqwY3ilNu5vqg32Y45fp+0Re5TNodAyNNMYMWLNnfCTc
         qMOF/xIWkwrxRAo1as9Zhdz0gGGX0F6PlT6lo=
Date: Sun, 8 Nov 2009 18:53:56 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
Message-ID: <20091108155356.GB25940@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole page is reserved for IO-APIC fixmap
due to non-cacheable requirement. So lets note
this explicitly instead of playing with numbers.

CC: Yinghai Lu <yinghai@kernel.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Perhaps I miss something and (4 * 1024) have some special
meaning?

 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -4144,7 +4144,7 @@ fake_ioapic_page:
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+		ioapic_res->end = ioapic_phys + PAGE_SIZE - 1;
 		ioapic_res++;
 	}
 }
