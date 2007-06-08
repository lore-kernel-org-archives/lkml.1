Return-Path: <linux-kernel-owner+w=401wt.eu-S965869AbXFHHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbXFHHTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936694AbXFHHRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33132 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937777AbXFHHRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:07 -0400
Message-Id: <20070608071548.844618000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sam Ravnborg <sam@ravnborg.org>, Andy Green <andy@warmcat.com>
Subject: [patch 17/32] kbuild: fixdep segfault on pathological string-o-death
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
Fixes https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241915

 scripts/basic/fixdep.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.13.orig/scripts/basic/fixdep.c
+++ linux-2.6.20.13/scripts/basic/fixdep.c
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
