Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZHSKRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZHSKRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZHSKRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:17:40 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:65256 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZHSKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LftR7tbN5jY54BDqFFHW1NDT41aP0CjCzeXJjxGdMlnS8on3l7p2epqYX27vLfe3s6
         JA/Fbz9ZtW63crvkWHyGlwGeHrHXjaBCVDBCEyKOWwfNQ2C9OPcqDousUqMhk8JkVP4a
         vT1B2Q/CCjCYAbnO54XOn4cwiU8TS5oVlGA6M=
Date: Wed, 19 Aug 2009 18:19:55 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] scripts: use non-builtin echo for '-e'
Message-ID: <20090819101955.GC5057@cr0.nay.redhat.com>
References: <20090819173854.2250758f@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819173854.2250758f@dxy.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alek reported that on Ubuntu, where dash is used, 'echo -e'
can't work, so let's use non-builtin echo in this case.

Reported-by: Alek Du <alek.du@intel.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index c29be8f..bace250 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -99,7 +99,7 @@ as-option = $(call try-run,\
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
index 39677c8..46be3c5 100755
--- a/scripts/checkkconfigsymbols.sh
+++ b/scripts/checkkconfigsymbols.sh
@@ -9,7 +9,7 @@ paths="$@"
 # Doing this once at the beginning saves a lot of time, on a cache-hot tree.
 Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
 
-echo -e "File list \tundefined symbol used"
+/bin/echo -e "File list \tundefined symbol used"
 find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
 do
 	# Output the bare Kconfig variable and the filename; the _MODULE part at
@@ -54,6 +54,6 @@ while read symb files; do
 	# beyond the purpose of this script.
 	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
 	if ! grep -q "\<$symb_bare\>" $Kconfigs; then
-		echo -e "$files: \t$symb"
+		/bin/echo -e "$files: \t$symb"
 	fi
 done|sort

