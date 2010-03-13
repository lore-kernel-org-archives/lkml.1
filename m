Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0CMF0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 00:26:53 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:35116 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0CMF0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 00:26:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w316/4E4GmYj3CRruLf3NilFL5tDFeMs0ZoCSP0jSrKbIXT3AjymzIOy4BDcFRzLBB
         C98gTvmsbVMm27h+V3RcY0IECYkRqbERuGq7ilH+WgJJwSAPrWHd5qx3bcrS+OUR2rFJ
         QpHGxg3OQBpb4DiEGUWEV7YEjPjpLSGhVX88Y=
Date: Sat, 13 Mar 2010 21:25:45 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       casey@schaufler-ca.com
Subject: [PATCH] Security: Add break judge to smk_import_entry() in security/smack/smack_access.c
Message-ID: <20100313132545.GB3126@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In smk_import_entry(), smack[i] = '\0' was set if found = 1, so:
if (found)
	smack[i] = '\0';
No need to continue again, just can break the loop.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/smack/smack_access.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 0f9ac81..0e064e8 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -318,7 +318,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 
 	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
 		if (found)
-			smack[i] = '\0';
+			break;
 		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
 			 string[i] == '/' || string[i] == '"' ||
 			 string[i] == '\\' || string[i] == '\'') {
-- 
1.6.5.3

