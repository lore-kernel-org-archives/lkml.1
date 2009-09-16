Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbZIPWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbZIPWkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbZIPWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:30 -0400
Received: from kroah.org ([198.145.64.141]:48992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbZIPWkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:17 2009
Message-Id: <20090916223717.186277850@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 27/45] x86: Fix x86_model test in es7000_apic_is_cluster()
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roel Kluin <roel.kluin@gmail.com>

commit 005155b1f626d2b2d7932e4afdf4fead168c6888 upstream.

For the x86_model to be greater than 6 or less than 12 is
logically always true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -167,7 +167,7 @@ static int es7000_apic_is_cluster(void)
 {
 	/* MPENTIUMIII */
 	if (boot_cpu_data.x86 == 6 &&
-	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11))
+	    (boot_cpu_data.x86_model >= 7 && boot_cpu_data.x86_model <= 11))
 		return 1;
 
 	return 0;


