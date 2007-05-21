Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXEUT2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXEUT2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765386AbXEUTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46358 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765311AbXEUTV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:29 -0400
Message-Id: <20070521191704.478576000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sam Ravnborg <sam@ravnborg.org>,
       Andy Green <andy@warmcat.com>
Subject: [patch 10/69] kbuild: fixdep segfault on pathological string-o-death
Content-Disposition: inline; filename=kbuild-fixdep-segfault-on-pathological-string-o-death.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andy Green <andy@warmcat.com>

build scripts: fixdep blows segfault on string CONFIG_MODULE seen

The string "CONFIG_MODULE" appearing anywhere in a source file causes
fixdep to segfault.  This string appeared in the wild in the current
mISDN sources (I think they meant CONFIG_MODULES).  But it shouldn't
segfault (esp as CONFIG_MODULE appeared in a quoted string).

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

This is not an important fix per see - but I do not like SEGV during compilation...
Will be pushed to Linus today.

	Sam

 scripts/basic/fixdep.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21.1.orig/scripts/basic/fixdep.c
+++ linux-2.6.21.1/scripts/basic/fixdep.c
@@ -249,6 +249,8 @@ void parse_config_file(char *map, size_t
 	found:
 		if (!memcmp(q - 7, "_MODULE", 7))
 			q -= 7;
+		if( (q-p-7) < 0 )
+			continue;
 		use_config(p+7, q-p-7);
 	}
 }

-- 
