Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZEYOoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZEYOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZEYOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:43:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZEYOn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:43:26 -0400
Date: Mon, 25 May 2009 16:43:27 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kbuild: add generic --set-str option to scripts/config
Message-ID: <20090525144327.GD22686@sepie.suse.cz>
References: <cover.1243262102.git.mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1243262102.git.mmarek@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/config |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/scripts/config b/scripts/config
index d3576e5..b4e56c9 100755
--- a/scripts/config
+++ b/scripts/config
@@ -9,8 +9,10 @@ config options command ...
 commands:
 	--enable|-e option   Enable option
 	--disable|-d option  Disable option
-	--module|-m option      Turn option into a module
-	--state|-s option       Print state of option (n,y,m,undef)
+	--module|-m option   Turn option into a module
+	--set-str option value
+	                     Set option to "value"
+	--state|-s option    Print state of option (n,y,m,undef)
 
 	--enable-after|-E beforeopt option
                              Enable option directly after other option
@@ -112,6 +114,11 @@ while [ "$1" != "" ] ; do
 		set_var "CONFIG_$ARG" "CONFIG_$ARG=m"
 		;;
 
+	--set-str)
+		set_var "CONFIG_$ARG" "CONFIG_$ARG=\"$1\""
+		shift
+		;;
+
 	--state|-s)
 		if grep -q "# CONFIG_$ARG is not set" $FN ; then
 			echo n
-- 
1.6.3
