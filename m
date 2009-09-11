Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZIKUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZIKUAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbZIKUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbZIKUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:33 -0400
Message-Id: <20090911200035.830978613@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:59:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 12/15] kconfig: test for /boot/config-uname after /proc/config.gz in localconfig
Content-Disposition: inline; filename=0012-kconfig-test-for-boot-config-uname-after-proc-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Many distros put their config in /boot/config-`uname -r`, add a check
for that right after /proc/config.gz

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
1.6.3.3

-- 
