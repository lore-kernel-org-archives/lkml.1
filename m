Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZKHPy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZKHPy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZKHPy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:54:28 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59912 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZKHPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:54:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=In4yx779y3RUgGadTMd7twl4bNH0orfTeFSg7+kJxNP2z+Lq40pnvvpj5V7J8CD+EM
         X6leDgTuqyJviO1auTvvfN+OSNYLAlT82DLEoOAa2M/fPzko+1Qr4XXuMUiVkl/ZNh4e
         fIral88k9TEx4Ph/G67Wm0qeM1irh33FM8RoE=
Date: Sun, 8 Nov 2009 18:54:31 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       x86team <x86@kernel.org>
Subject: [PATCH -tip] x86,ioapic: use snrpintf while set names for IO-APIC
	resourses
Message-ID: <20091108155431.GC25940@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be ready that one day MAX_IO_APICS may raise its
number. To prevent memory overwrite we're to use safe
snprintf while set IO-APIC resourse name.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -4099,7 +4099,7 @@ static struct resource * __init ioapic_s
 	for (i = 0; i < nr_ioapics; i++) {
 		res[i].name = mem;
 		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		sprintf(mem,  "IOAPIC %u", i);
+		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 	}
 
