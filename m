Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257Ab0AEAh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0AEAh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571Ab0AEAhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:37:33 -0500
Received: from kroah.org ([198.145.64.141]:42539 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0AEAgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 95/97] lguest: fix bug in setting guest GDT entry
Date: Mon,  4 Jan 2010 16:33:48 -0800
Message-Id: <1262651630-7354-95-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

commit 3e27249c84beed1c79d767b350e52ad038db9053 upstream.

We kill the guest, but then we blatt random stuff.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/lguest/segments.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index 951c57b..ede4658 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -179,8 +179,10 @@ void load_guest_gdt_entry(struct lg_cpu *cpu, u32 num, u32 lo, u32 hi)
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
-- 
1.6.6

