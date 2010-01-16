Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0APJnL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305Ab0APJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:43:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:54151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0APJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:43:08 -0500
Date: Sat, 16 Jan 2010 09:42:38 GMT
From: tip-bot for Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jan.kiszka@siemens.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jan.kiszka@siemens.com
In-Reply-To: <4B4AFE10.8050109@siemens.com>
References: <4B4AFE10.8050109@siemens.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/x86: Derive arch from bits argument in recordmcount.pl
Message-ID: <tip-b82a4045f7962483a78a874343dc6e31b79c96c1@git.kernel.org>
Git-Commit-ID: b82a4045f7962483a78a874343dc6e31b79c96c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:42:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b82a4045f7962483a78a874343dc6e31b79c96c1
Gitweb:     http://git.kernel.org/tip/b82a4045f7962483a78a874343dc6e31b79c96c1
Author:     Jan Kiszka <jan.kiszka@siemens.com>
AuthorDate: Mon, 11 Jan 2010 11:31:44 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 11 Jan 2010 23:49:35 -0500

tracing/x86: Derive arch from bits argument in recordmcount.pl

Let the arch argument be overruled by bits. Otherwise, building of
external modules against a i386 target on a x86-64 host (and likely vice
versa as well) fails unless ARCH=i386 is explicitly passed to make.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
LKML-Reference: <4B4AFE10.8050109@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 92f09fe..ea6f6e3 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -194,7 +194,7 @@ sub check_objcopy
     }
 }
 
-if ($arch eq "x86") {
+if ($arch =~ /(x86(_64)?)|(i386)/) {
     if ($bits == 64) {
 	$arch = "x86_64";
     } else {
