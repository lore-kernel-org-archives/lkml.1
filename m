Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYJIPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYJIPW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbYJIPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:22:40 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37952 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306AbYJIPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:22:39 -0400
Date: Thu, 9 Oct 2008 11:20:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       hbabu@us.ibm.com
Cc: nhorman@tuxdriver.com
Subject: [PATCH] add additional symbols to /sys/kernel/vmcoreinfo data for ppc(64)
Message-ID: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey-
	The makdumpdile dump filtering program, in some modes of operation needs
the node_data and/or contig_page_data symbols to function properly.  These
symbols are missing from the powerpc kernel.  This patch adds those symbols in
properly.  Tested successfully by myself and the reporter.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 machine_kexec.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index aab7688..2f9b5aa 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -44,6 +44,16 @@ void machine_kexec_cleanup(struct kimage *image)
 		ppc_md.machine_kexec_cleanup(image);
 }
 
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#else
+	VMCOREINFO_SYMBOL(contig_page_data);
+#endif
+}
+
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
