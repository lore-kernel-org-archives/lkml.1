Return-Path: <linux-kernel-owner+w=401wt.eu-S1161275AbXCGHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbXCGHeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161276AbXCGHbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:31:34 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50146 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161275AbXCGH14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:56 -0500
Date: Wed, 7 Mar 2007 12:46:03 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 13/20] x86_64: Modify discover_ebda to use virtual addresses
Message-ID: <20070307071603.GN23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 arch/x86_64/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/setup.c~x86_64-Modify-discover_ebda-to-use-virtual-addresses arch/x86_64/kernel/setup.c
--- linux-2.6.21-rc2-reloc/arch/x86_64/kernel/setup.c~x86_64-Modify-discover_ebda-to-use-virtual-addresses	2007-03-07 01:28:51.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/kernel/setup.c	2007-03-07 01:28:51.000000000 +0530
@@ -205,10 +205,10 @@ static void discover_ebda(void)
 	 * there is a real-mode segmented pointer pointing to the 
 	 * 4K EBDA area at 0x40E
 	 */
-	ebda_addr = *(unsigned short *)EBDA_ADDR_POINTER;
+	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
 	ebda_addr <<= 4;
 
-	ebda_size = *(unsigned short *)(unsigned long)ebda_addr;
+	ebda_size = *(unsigned short *)__va(ebda_addr);
 
 	/* Round EBDA up to pages */
 	if (ebda_size == 0)
_
