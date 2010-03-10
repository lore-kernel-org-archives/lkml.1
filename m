Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0CJMyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:54:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47285 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0CJMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=REHfRcIxnDsZ+kyxIffAWPHr/O7HPZf2KiTXJvzh9W9ptAGddbM+Ib1/4ld3OST9g+
         Amv0pSv8N5+K4odWd8XTOL8zoOt+kcny1K//aQFX/fLGjLhiBiWIQBOFZGlHR5JzP2X3
         5F2yUOAf29u7Ncy2njmC4nNCQi6F0hjqnQevE=
Date: Thu, 11 Mar 2010 04:53:48 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: [PATCH] Security: Fix return value of avc_has_perm_noaudit() in security/selinux/avc.c
Message-ID: <20100310205348.GA3419@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avc_has_perm_noaudit() is not check the return value of avc_update_node, avc_update_node() delcared as int.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/selinux/avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index f2dde26..8bbce96 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -763,7 +763,7 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 		if (flags & AVC_STRICT)
 			rc = -EACCES;
 		else if (!selinux_enforcing || (avd->flags & AVD_FLAGS_PERMISSIVE))
-			avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
+			rc = avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
 					tsid, tclass, avd->seqno);
 		else
 			rc = -EACCES;
-- 
1.6.5.3

