Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZIKUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZIKUAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZIKUAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:00:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbZIKUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:00:33 -0400
Message-Id: <20090911200036.117261078@goodmis.org>
References: <20090911195849.451244684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:59:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dick Streefland <dick@streefland.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 13/15] kconfig: make local .config default for streamline_config
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
