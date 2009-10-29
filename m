Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZJ2Nrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZJ2Nrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZJ2Nrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:47:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:49042 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZJ2Nrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gig/4P3UzQpYhuUx+v7NqR8am7j6AwOLF2a+mAkYWUcNeqtWB8BN3rYv2J/K87xfUc
         1RgL0gZYfJJCOnx4D7C4XBk6NQTH1whDyRyIc5OQ+EJlAOMrDEe3+mydMY6imYMX+vc2
         e4BNejgNzu0J5KyEzIwgLbC0o0Lv7WFDzxjJI=
Date: Thu, 29 Oct 2009 14:47:42 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, amd-ucode: Remove needless log messages
Message-ID: <20091029134742.GD30802@alberich.amd.com>
References: <20091029134552.GC30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029134552.GC30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index f4c538b..c043534 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -109,12 +109,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		return 0;
 	}
 
-	if (mc_header->processor_rev_id != equiv_cpu_id) {
-		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
-		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
-		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
+	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;
-	}
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
@@ -185,9 +181,6 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
-	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
-	       size, total_size);
-
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
 		printk(KERN_ERR "microcode: error: size mismatch\n");
 		return NULL;
-- 
1.6.5.1

