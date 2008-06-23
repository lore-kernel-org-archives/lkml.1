Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYFWXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYFWXI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYFWXHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:07:23 -0400
Received: from mail.suse.de ([195.135.220.2]:44514 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbYFWXHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:07:21 -0400
Date: Mon, 23 Jun 2008 16:04:58 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>
Subject: [patch 06/10] Add return value to reserve_bootmem_node()
Message-ID: <20080623230458.GF29853@suse.de>
References: <20080623225737.837265824@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-return-value-to-reserve_bootmem_node.patch"
In-Reply-To: <20080623230417.GA29853@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25.9-stable review patch.  If anyone has any objections, please let
us know.

------------------ 
From: Bernhard Walle <bwalle@suse.de>

commit 71c2742f5e6348d76ee62085cf0a13e5eff0f00e upstream

This patch changes the function reserve_bootmem_node() from void to int,
returning -ENOMEM if the allocation fails.

This fixes a build problem on x86 with CONFIG_KEXEC=y and
CONFIG_NEED_MULTIPLE_NODES=y

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/bootmem.h |    2 +-
 mm/bootmem.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -94,7 +94,7 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long freepfn,
 				       unsigned long startpfn,
 				       unsigned long endpfn);
-extern void reserve_bootmem_node(pg_data_t *pgdat,
+extern int reserve_bootmem_node(pg_data_t *pgdat,
 				 unsigned long physaddr,
 				 unsigned long size,
 				 int flags);
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -398,10 +398,10 @@ unsigned long __init init_bootmem_node(p
 	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
 }
 
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
-	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	return reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,

-- 
