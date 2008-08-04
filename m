Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbYHDUUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbYHDUUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbYHDUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:19:52 -0400
Received: from ns.suse.de ([195.135.220.2]:48232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbYHDUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:19:51 -0400
Date: Mon, 4 Aug 2008 13:14:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 02/33] x86: ioremap of 64-bit resource on 32-bit kernel fix
Message-ID: <20080804201442.GC1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="linux-2.6-x86-mm-ioremap-64-bit-resource-on-32-bit-kernel.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

commit 756a6c68556600aec9460346332884d891d5beb4 upstream

x86: ioremap of 64-bit resource on 32-bit kernel fix

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -39,7 +39,7 @@ EXPORT_SYMBOL(__phys_addr);
 
 int page_is_ram(unsigned long pagenr)
 {
-	unsigned long addr, end;
+	resource_size_t addr, end;
 	int i;
 
 	/*
@@ -109,7 +109,8 @@ static int ioremap_change_attr(unsigned 
 static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, vaddr;
+	resource_size_t last_addr;
 	struct vm_struct *area;
 	pgprot_t prot;
 

-- 
