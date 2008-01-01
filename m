Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYAAKMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYAAKMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYAAKMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:12:42 -0500
Received: from sa2.bezeqint.net ([192.115.104.16]:59786 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYAAKMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:12:41 -0500
Message-ID: <477A1206.4070805@panasas.com>
Date: Tue, 01 Jan 2008 12:12:22 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: lkml <linux-kernel@vger.kernel.org>, Joel Schopp <jschopp@austin.ibm.com>
Subject: [PATCH] checkpatch.pl: recognize the #elif preprocessor directive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl does not recognize #elif as a preprocessor directive
causing it to print bogus errors for, e.g.:
ERROR: need consistent spacing around '&' (ctx:WxV)
when the operator is not recognized as unary in this context.

for example:

void foo(void)
{
	int x, y, z;
	void *p[1] = {
#if defined(X)
		&x
#elif defined(Y)
		&y
#else
		&z
#endif
	};
}

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..9911c17 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -534,7 +534,7 @@ sub annotate_values {
 			$preprocessor = 1;
 			$paren_type[$paren] = 'N';
 
-		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|endif))/o) {
+		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|elif|endif))/o) {
 			print "PRE($1)\n" if ($debug);
 			$preprocessor = 1;
 			$type = 'N';

