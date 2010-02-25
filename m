Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab0BYTT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:19:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38235 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab0BYTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:19:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=rouUatBKaW4A:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1ONS5zeUHWOoR2GVVjUA:9 a=AEPzIhB2b7JZ9Um5r_OnGFIBtiAA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225191953.310424002@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:17:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 1/5] kconfig: Create include/generated for localmodconfig
References: <20100225191755.483925025@goodmis.org>
Content-Disposition: inline; filename=0001-kconfig-Create-include-generated-for-localmodconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If someone downloads a brand new kernel and runs localmodconfig or
localyesconfig, the ending result will report:

 *** Error during update of the kernel configuration.

This is because localmodconfig and localyesconfig must create the
include/generated directory to place the autoconf.h file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 999e8a7..006c96f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -31,6 +31,7 @@ silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
+	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
@@ -45,6 +46,7 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)rm -f .tmp.config
 
 localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
+	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
 	$(Q)if [ -f .config ]; then 				\
-- 
1.6.5


