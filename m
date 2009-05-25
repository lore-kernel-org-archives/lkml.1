Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZEYM4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZEYM4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZEYMzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:55:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZEYMzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:55:45 -0400
Date: Mon, 25 May 2009 14:55:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kbuild: simplify argument loop in scripts/config
Message-ID: <20090525125546.GC12943@sepie.suse.cz>
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
 scripts/config |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/scripts/config b/scripts/config
index 144e4b0..731c4a7 100755
--- a/scripts/config
+++ b/scripts/config
@@ -77,8 +77,7 @@ if [ "$1" = "--file" ]; then
 	if [ "$FN" = "" ] ; then
 		usage
 	fi
-	shift
-	shift
+	shift 2
 else
 	FN=.config
 fi
@@ -91,26 +90,34 @@ while [ "$1" != "" ] ; do
 	CMD="$1"
 	shift
 	case "$CMD" in
-	--enable|-e)
+	--refresh)
+		;;
+	--*-after)
+		checkarg "$1"
+		A=$ARG
+		checkarg "$2"
+		B=$ARG
+		shift 2
+		;;
+	--*)
 		checkarg "$1"
-		set_var "CONFIG_$ARG" "CONFIG_$ARG=y"
 		shift
 		;;
+	esac
+	case "$CMD" in
+	--enable|-e)
+		set_var "CONFIG_$ARG" "CONFIG_$ARG=y"
+		;;
 
 	--disable|-d)
-		checkarg "$1"
 		set_var "CONFIG_$ARG" "# CONFIG_$ARG is not set"
-		shift
 		;;
 
 	--module|-m)
-		checkarg "$1"
 		set_var "CONFIG_$ARG" "CONFIG_$ARG=m"
-		shift
 		;;
 
 	--state|-s)
-		checkarg "$1"
 		if grep -q "# CONFIG_$ARG is not set" $FN ; then
 			echo n
 		else
@@ -123,37 +130,18 @@ while [ "$1" != "" ] ; do
 				echo "$V"
 			fi
 		fi
-		shift
 		;;
 
 	--enable-after|-E)
-		checkarg "$1"
-		A=$ARG
-		checkarg "$2"
-		B=$ARG
 		set_var "CONFIG_$B" "CONFIG_$B=y" "CONFIG_$A"
-		shift
-		shift
 		;;
 
 	--disable-after|-D)
-		checkarg "$1"
-		A=$ARG
-		checkarg "$2"
-		B=$ARG
 		set_var "CONFIG_$B" "# CONFIG_$B is not set" "CONFIG_$A"
-		shift
-		shift
 		;;
 
 	--module-after|-M)
-		checkarg "$1"
-		A=$ARG
-		checkarg "$2"
-		B=$ARG
 		set_var "CONFIG_$B" "CONFIG_$B=m" "CONFIG_$A"
-		shift
-		shift
 		;;
 
 	# undocumented because it ignores --file (fixme)
-- 
1.6.3

