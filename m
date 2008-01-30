Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYA3Qk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYA3Qk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbYA3QkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:40:07 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:64892 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYA3QkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:40:05 -0500
X-IronPort-AV: E=Sophos;i="4.25,278,1199682000"; 
   d="scan'208";a="47653411"
Subject: [PATCH 1/1 try#2] [Scripts] add svn revision information to
	setlocalversion
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080130102442.GB20846@uranus.ravnborg.org>
References: <1201688125-1387-1-git-send-email-bryan.wu@analog.com>
	 <20080130102442.GB20846@uranus.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 31 Jan 2008 00:39:39 +0800
Message-Id: <1201711179.6463.3.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 30 Jan 2008 16:40:04.0077 (UTC) FILETIME=[C3A909D0:01C8635E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f2adf444236eb3a4dcf5104dfbc1c5e1d5886c76 Mon Sep 17 00:00:00 2001
From: Bryan Wu <bryan.wu@analog.com>
Date: Thu, 31 Jan 2008 00:38:16 +0800
Subject: [PATCH] [Scripts] add svn revision information to setlocalversion

[try #2]: follow git and mercurial style, add uncommitted changes detect

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 scripts/setlocalversion |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 scripts/setlocalversion

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
old mode 100644
new mode 100755
index 52f032e..17b0028
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -45,3 +45,18 @@ if hgid=`hg id 2>/dev/null`; then
 	# All done with mercurial
 	exit
 fi
+
+# Check for svn and a svn repo.
+if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
+	changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l`
+
+	# Are there uncommitted changes?
+	if [ $changes != 0 ]; then
+		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+	else
+		printf -- '-svn%s' "$rev"
+	fi
+
+	# All done with svn
+	exit
+fi
-- 
1.5.3.4

