Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZJTQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZJTQzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZJTQzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:55:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbZJTQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:55:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 1/2] x86: Fix group attribute decoding bug
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Oct 2009 12:55:24 -0400
Message-ID: <20091020165524.4145.97333.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in inat_get_group_attribute() which should refer
inat_group_tables, not inat_escape_tables.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
