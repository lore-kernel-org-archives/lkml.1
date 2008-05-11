Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYEKRPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYEKRPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYEKRPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:15:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49045 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYEKRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:content-disposition:to:cc:content-type:content-transfer-encoding:message-id:sender;
        b=qNmKJT0IKUOKHKukwC4ZiAB8nGSZScQRopN6wSqA1Zr/KGDTWUqrsFOTxkXR4V0VHZJYp0/aPLvLvFnvGXTQIU4VcTvqbK8XkV6smt82hNgpLgotSODK8gqZL+mMUb9ZnDAClFcXX8pKekgwUSftxB/i+9dSQMOBpMKwwiUntAw=
From: Leonardo Potenza <lpotenza@inwind.it>
Subject: [PATCH] fs/dlm: section mismatch warning fix
Date: Sun, 11 May 2008 19:15:34 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: kernel-janitors@vger.kernel.org
Cc: ccaulfie@redhat.com, teigland@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805111915.34911.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Removed the section mismatch message:
WARNING: fs/dlm/dlm.o(.init.text+0x132): Section mismatch in reference from the function init_module() to the function .exit.text:dlm_netlink_exit()

Since dlm_netlink_exit() is called in the init_dlm() error handling,
the __exit annotation has been removed.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

 netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/dlm/netlink.c
===================================================================
--- linux-2.6.orig/fs/dlm/netlink.c
+++ linux-2.6/fs/dlm/netlink.c
@@ -95,7 +95,7 @@ int __init dlm_netlink_init(void)
 	return rv;
 }
 
-void __exit dlm_netlink_exit(void)
+void dlm_netlink_exit(void)
 {
 	genl_unregister_ops(&family, &dlm_nl_ops);
 	genl_unregister_family(&family);
