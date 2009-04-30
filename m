Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZD3Xix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZD3Xix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZD3XiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:38:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZD3XiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:38:00 -0400
Message-Id: <20090430233758.444232604@goodmis.org>
References: <20090430233642.333097165@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 19:36:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: [PATCH 2/2] kconfig: test for /boot/config-uname after /proc/config.gz in localconfig
Content-Disposition: inline; filename=0002-kconfig-test-for-boot-config-uname-after-proc-con.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Many distros put their config in /boot/config-`uname -r`, add a check
for that right after /proc/config.gz

[ Impact: use distro config as default to streamline_config.pl ]

Reported-by: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 69b7c3f..46ca62d 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -54,6 +54,10 @@ my @searchconfigs = (
 	    "exec" => "zcat",
 	},
 	{
+	    "file" => "/boot/config-$uname",
+	    "exec" => "cat",
+	},
+	{
 	    "file" => "/boot/vmlinuz-$uname",
 	    "exec" => "scripts/extract-ikconfig",
 	    "test" => "scripts/extract-ikconfig",
-- 
1.6.2.1

-- 
