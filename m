Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZHSDBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZHSDBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZHSDAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZHSDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:39 -0400
Message-Id: <20090819030039.369922264@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 12/14] kconfig: test for /boot/config-uname after /proc/config.gz in localconfig
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
