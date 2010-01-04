Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250Ab0ADI4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0ADI4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 03:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169Ab0ADI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 03:56:19 -0500
Received: from ozlabs.org ([203.10.76.45]:32851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0ADI4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 03:56:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lguest: fix bug in setting guest GDT entry
Date: Mon, 4 Jan 2010 19:26:14 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       Dan Carpenter <error27@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001041926.15086.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We kill the guest, but then we blatt random stuff.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
---
 drivers/lguest/segments.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -179,8 +179,10 @@ void load_guest_gdt_entry(struct lg_cpu 
 	 * We assume the Guest has the same number of GDT entries as the
 	 * Host, otherwise we'd have to dynamically allocate the Guest GDT.
 	 */
-	if (num >= ARRAY_SIZE(cpu->arch.gdt))
+	if (num >= ARRAY_SIZE(cpu->arch.gdt)) {
 		kill_guest(cpu, "too many gdt entries %i", num);
+		return;
+	}
 
 	/* Set it up, then fix it. */
 	cpu->arch.gdt[num].a = lo;
