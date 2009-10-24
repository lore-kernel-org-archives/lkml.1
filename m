Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZJXBE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZJXBE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZJXBEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:51730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZJXBEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:46 -0400
Date: Sat, 24 Oct 2009 01:03:50 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091020165524.4145.97333.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091020165524.4145.97333.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86: Fix group attribute decoding bug
Message-ID: <tip-06ed6ba5ecb771cc3a967838a4bb1d9cbd8786b9@git.kernel.org>
Git-Commit-ID: 06ed6ba5ecb771cc3a967838a4bb1d9cbd8786b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06ed6ba5ecb771cc3a967838a4bb1d9cbd8786b9
Gitweb:     http://git.kernel.org/tip/06ed6ba5ecb771cc3a967838a4bb1d9cbd8786b9
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 20 Oct 2009 12:55:24 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 13:25:28 +0200

x86: Fix group attribute decoding bug

Fix a typo in inat_get_group_attribute() which should refer
inat_group_tables, not inat_escape_tables.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap<systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020165524.4145.97333.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/inat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index 054656a..3fb5998 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -68,7 +68,7 @@ insn_attr_t inat_get_group_attribute(insn_byte_t modrm, insn_byte_t last_pfx,
 	if (!table)
 		return inat_group_common_attribute(grp_attr);
 	if (inat_has_variant(table[X86_MODRM_REG(modrm)]) && m) {
-		table = inat_escape_tables[n][m];
+		table = inat_group_tables[n][m];
 		if (!table)
 			return inat_group_common_attribute(grp_attr);
 	}
