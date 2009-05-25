Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZEYM43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZEYM43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZEYMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:55:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:36974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbZEYMzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:55:49 -0400
Date: Mon, 25 May 2009 14:55:50 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kbuild: add generic --set option to scripts/config
Message-ID: <20090525125550.GD12943@sepie.suse.cz>
References: <cover.1243255664.git.mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1243255664.git.mmarek@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/config |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/config b/scripts/config
index 731c4a7..38eeff7 100755
--- a/scripts/config
+++ b/scripts/config
@@ -9,8 +9,11 @@ config options command ...
 commands:
 	--enable|-e option   Enable option
 	--disable|-d option  Disable option
-	--module|-m option      Turn option into a module
-	--state|-s option       Print state of option (n,y,m,undef)
+	--module|-m option   Turn option into a module
+	--set option value   Set option to arbitrary value
+	--set-str option value
+	                     Same as --set, bu quote value
+	--state|-s option    Print state of option (n,y,m,undef)
 
 	--enable-after|-E beforeopt option
                              Enable option directly after other option
@@ -117,6 +120,16 @@ while [ "$1" != "" ] ; do
 		set_var "CONFIG_$ARG" "CONFIG_$ARG=m"
 		;;
 
+	--set)
+		set_var "CONFIG_$ARG" "CONFIG_$ARG=$1"
+		shift
+		;;
+
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
