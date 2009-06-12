Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZFLTZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZFLTZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZFLTZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:25:10 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26502 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZFLTZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:25:09 -0400
X-SpamScore: 5
X-BigFish: VPS5(z34a4jzzz1202hzzz32i6bh17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KL54LF-04-N5L-01
Date: Fri, 12 Jun 2009 21:24:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/oprofile: fix initialization of arch_perfmon for
	core_i7
Message-ID: <20090612192441.GA29081@erda.amd.com>
References: <1244810140-20595-3-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1244810140-20595-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2009 19:24:56.0594 (UTC) FILETIME=[78309720:01C9EB93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit:

 e419294 x86/oprofile: moving arch_perfmon counter setup to op_x86_model_spec.init

introduced a bug in the initialization of core_i7 leading to the
incorrect model setup to &op_ppro_spec. This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

You may pull the patch from the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master

The branch also contains the merge with tip/perfcounters-for-linus to
solve merge conflicts with Linus' tree.

-Robert

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 7826dfc..28ee490 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -406,6 +406,7 @@ module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
+	struct op_x86_model_spec const *spec = &op_ppro_spec;	/* default */
 
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
@@ -432,7 +433,7 @@ static int __init ppro_init(char **cpu_type)
 		*cpu_type = "i386/core_2";
 		break;
 	case 26:
-		model = &op_arch_perfmon_spec;
+		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
 	case 28:
@@ -443,7 +444,7 @@ static int __init ppro_init(char **cpu_type)
 		return 0;
 	}
 
-	model = &op_ppro_spec;
+	model = spec;
 	return 1;
 }
 
-- 
1.6.3.1

