Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYHBIZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYHBIZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 04:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYHBIZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 04:25:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYHBIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 04:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YFqHiuSX+nhDTEWgbli0J1fFNdeFRyc8lo7tE3l0MTJqsx9/HE5EInhprQcrz1Omfc
         TNiPPIXxDW0Epyo1T+i6uukfiSCiT1p6JDCT1lHCLEZLy3/cROn1t7Fx+/cXiIa+8bfl
         jj6EKv8kInZ9pFhcQuo3saztHfKQdEgbIMPm0=
Date: Sat, 2 Aug 2008 12:24:54 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: righi.andrea@gmail.com, oleg@tv-sign.ru, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: fix warnings
Message-ID: <20080802082454.GB4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

proc: fix warnings

fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 3 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 4 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 5 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 6 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 7 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 8 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 9 has type 'u64'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---

 fs/proc/base.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01ed610..a28840b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2423,10 +2423,13 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			acct.rchar, acct.wchar,
-			acct.syscr, acct.syscw,
-			acct.read_bytes, acct.write_bytes,
-			acct.cancelled_write_bytes);
+			(unsigned long long)acct.rchar,
+			(unsigned long long)acct.wchar,
+			(unsigned long long)acct.syscr,
+			(unsigned long long)acct.syscw,
+			(unsigned long long)acct.read_bytes,
+			(unsigned long long)acct.write_bytes,
+			(unsigned long long)acct.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
