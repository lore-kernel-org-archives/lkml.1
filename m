Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbYDPRhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbYDPRhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYDPRhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:37:13 -0400
Received: from baikonur.stro.at ([213.239.196.228]:36074 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYDPRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:37:12 -0400
Date: Wed, 16 Apr 2008 19:36:36 +0200
From: maximilian attems <max@stro.at>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Martin Michlmayr <tbm@cyrius.com>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: [PATCH] Kconfig: enhance DEFAULT_MMAP_MIN_ADDR description
Message-ID: <20080416173636.GB19260@stro.at>
References: <1208366024-20261-1-git-send-email-max@stro.at> <1208366589.12707.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208366589.12707.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got burned by setting the proposed default of 65536
across all Debian archs.

Thus proposing to be more specific on which archs you may
set this. Also propose a value for arm and friends that
doesn't break sshd.

Reword to mention working archs ia64 and ppc64 too.

Signed-off-by: maximilian attems <max@stro.at>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>
Acked-by: Eric Paris <eparis@redhat.com>

diff --git a/security/Kconfig b/security/Kconfig
index 5dfc206..49b51f9 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -113,10 +113,12 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  from userspace allocation.  Keeping a user from writing to low pages
 	  can help reduce the impact of kernel NULL pointer bugs.
 
-	  For most users with lots of address space a value of 65536 is
-	  reasonable and should cause no problems.  Programs which use vm86
-	  functionality would either need additional permissions from either
-	  the LSM or the capabilities module or have this protection disabled.
+	  For most ia64, ppc64 and x86 users with lots of address space
+	  a value of 65536 is reasonable and should cause no problems.
+	  On arm and other archs it should not be higher than 32768.
+	  Programs which use vm86 functionality would either need additional
+	  permissions from either the LSM or the capabilities module or have
+	  this protection disabled.
 
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
