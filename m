Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbYGXExy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbYGXExy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 00:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGXExo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 00:53:44 -0400
Received: from ozlabs.org ([203.10.76.45]:60924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYGXExn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 00:53:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/2] scripts/package: don't break if %{_smp_mflags} isn't set
Message-Id: <1216875061.442005.468797861549.1.gpush@pingu>
To: <linux-kernel@vger.kernel.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Thu, 24 Jul 2008 14:51:01 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if we do a 'make rpm-pkg' without the _smp_mflags rpm macro
defined, the build fails with:

  [snip]
  Executing(%build): /bin/bash -e /var/tmp/rpm-tmp.67959
  + umask 022
  + cd /home/jk/devel/kernel-snapshot/rpm/BUILD
  + cd kernel-2.6.26
  + make clean
  + make '%{_smp_mflags}'
  make[3]: *** No rule to make target `%{_smp_mflags}'.  Stop.
  error: Bad exit status from /var/tmp/rpm-tmp.67959 (%build)

This change uses the 'null if not set' reference to the _smp_mflags
macro instead.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 scripts/package/mkspec |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ffd61fe..20f7da6 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -57,7 +57,7 @@ fi
 echo "%build"
 
 if ! $PREBUILT; then
-echo "make clean && make %{_smp_mflags}"
+echo "make clean && make %{?_smp_mflags}"
 echo ""
 fi
 
