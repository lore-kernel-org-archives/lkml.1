Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYKUKkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYKUKkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKUKkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:40:31 -0500
Received: from ozlabs.org ([203.10.76.45]:56307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYKUKkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:40:31 -0500
To: Adam Belay <ambx1@neo.rr.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:10:25 +1030
Subject: [PATCH 2/3] percpu: fix percpu accessors to potentially !cpu_possible() cpus: pnpbios
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Adam Belay <ambx1@neo.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212110.25549.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: CPU iterator bugfixes

Percpu areas are only allocated for possible cpus.  In general, you
shouldn't access random cpu's percpu areas.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Adam Belay <ambx1@neo.rr.com>
---
 drivers/pnp/pnpbios/bioscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r
--- test-compile.orig/drivers/pnp/pnpbios/bioscalls.c
+++ test-compile/drivers/pnp/pnpbios/bioscalls.c
@@ -481,7 +481,7 @@ void pnpbios_calls_init(union pnp_bios_i
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;


