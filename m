Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYHSKBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYHSKBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYHSKB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:01:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:52081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752995AbYHSKB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:01:28 -0400
X-Authenticated: #628067
X-Provags-ID: V01U2FsdGVkX1/RfQBdzarRfQVQHmRbCahuZz3/0chQUwqHSexKCB
	WgOqObvDotdJRc
Message-ID: <48AA99F5.7040200@gmx.net>
Date: Tue, 19 Aug 2008 12:01:25 +0200
From: Thomas Volpini <tvolpini@gmx.net>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checksyscalls.sh and non-gnu sed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the following patch makes the checksyscalls script work even on systems 
where sed is non-gnu.

best regards,
Thomas



diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 366f8c7..fdfb625 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -113,10 +113,10 @@ EOF
  }

  syscall_list() {
-sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
+sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
  \#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
  \#warning syscall \1 not implemented\
-\#endif/p }' $1
+\#endif/p' $1
  }
