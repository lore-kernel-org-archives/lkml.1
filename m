Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZETFPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZETFPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZETFPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:15:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZETFPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:15:12 -0400
Subject: [PATCH -tip] Documentation/accounting/getdelays.c intialize the
 variable before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@in.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 May 2009 10:44:44 +0530
Message-Id: <1242796484.3260.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


May be in some cases cmd_type will be used uninitialized.

Also fixes compilation warning:

   CC [M]  Documentation/DocBook/procfs_example.o
  Documentation/accounting/getdelays.c: In function ‘main’:
  Documentation/accounting/getdelays.c:249: warning: ‘cmd_type’ may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/accounting/getdelays.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 7ea2311..36aae3b 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -246,7 +246,7 @@ void print_ioacct(struct taskstats *t)
 
 int main(int argc, char *argv[])
 {
-	int c, rc, rep_len, aggr_len, len2, cmd_type;
+	int c, rc, rep_len, aggr_len, len2, cmd_type = TASKSTATS_CMD_ATTR_UNSPEC;
 	__u16 id;
 	__u32 mypid;
 
-- 
1.6.1.1



