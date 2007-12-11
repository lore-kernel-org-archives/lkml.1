Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXLKMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXLKMcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXLKMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:32:08 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:39574
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbXLKMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:32:07 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 07:32:06 EST
X-IronPort-AV: E=Sophos;i="4.24,152,1196636400"; 
   d="scan'208";a="6697281"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] kbuild: Re-enable Makefile generation in a new O=... directory
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jay Cliburn <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2007 13:22:08 +0100
Message-ID: <20071211122208.4050.34387.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch kbuild: fix building with O=.. options
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=18c32dac75b187d1a4e858f3cfdf03e844129f5e
disabled the creation of a Makefile in a new O=... directory. Restore it.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 scripts/mkmakefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 9ad1bd7..e0f54b9 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -13,7 +13,7 @@
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
 # Only overwrite automatically generated Makefiles
 # (so we do not overwrite kernel Makefile)
-if ! grep -q Automatically $2/Makefile
+if test -e $2/Makefile && ! grep -q Automatically $2/Makefile
 then
 	exit 0
 fi
