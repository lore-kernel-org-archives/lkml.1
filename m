Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYGHXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYGHXZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYGHXPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:01 -0400
Received: from gw.goop.org ([64.81.55.164]:51200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 45 of 55] xen: make sure the kernel command line is right
X-Mercurial-Node: 0084a04367192aa02cfae17534f60834c057c156
Message-Id: <0084a04367192aa02cfa.1215554827@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Point the boot params cmd_line_ptr to the domain-builder-provided
command line.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1587,6 +1587,7 @@
 	boot_params.hdr.ramdisk_image = xen_start_info->mod_start
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
+	boot_params.hdr.cmd_line_ptr = __pa(xen_start_info->cmd_line);
 
 	if (!is_initial_xendomain()) {
 		add_preferred_console("xenboot", 0, NULL);


