Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZHSDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZHSDAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZHSDAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61051 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZHSDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:39 -0400
Message-Id: <20090819030039.659167675@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:47 -0400
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
Subject: [PATCH 13/14] kconfig: make local .config default for streamline_config
Content-Disposition: inline; filename=0013-kconfig-make-local-.config-default-for-streamline_co.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As Andi Kleen pointed out, most people would expect that the local .config
file to be based for a streamline config. This patch changes the order
of searching for a config file to consider the .config in the local
directory first.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 46ca62d..95984db 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -50,6 +50,10 @@ chomp $uname;
 
 my @searchconfigs = (
 	{
+	    "file" => ".config",
+	    "exec" => "cat",
+	},
+	{
 	    "file" => "/proc/config.gz",
 	    "exec" => "zcat",
 	},
@@ -82,10 +86,6 @@ my @searchconfigs = (
 	    "exec" => "scripts/extract-ikconfig",
 	    "test" => "scripts/extract-ikconfig",
 	},
-	{
-	    "file" => ".config",
-	    "exec" => "cat",
-	},
 );
 
 sub find_config {
-- 
1.6.3.3

-- 
