Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYJTAa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYJTAa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 20:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYJTAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 20:30:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYJTAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 20:30:14 -0400
Date: Sun, 19 Oct 2008 20:28:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hbabu@us.ibm.com
Subject: Re: [PATCH] add additional symbols to /sys/kernel/vmcoreinfo data
	for ppc(64)
Message-ID: <20081020002805.GA23009@localhost.localdomain>
References: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com> <20081017210854.GB10013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017210854.GB10013@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hey Vivek, as promised, a corrected patch
	
	The makdumpdile dump filtering program, in some modes of operation needs
the node_data and/or contig_page_data symbols to function properly.  These
symbols are missing from the powerpc kernel.  This patch adds those symbols in
properly.  Tested successfully by myself and the reporter.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 machine_kexec.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index aab7688..5d51e75 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -44,6 +44,14 @@ void machine_kexec_cleanup(struct kimage *image)
 		ppc_md.machine_kexec_cleanup(image);
 }
 
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
+}
+
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
