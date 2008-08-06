Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYHFRWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYHFRWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYHFRWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:22:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:57858 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760AbYHFRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jWjhNEvOB2eIR4J7ldYG3XfgBgXzye4pd2tF1mGsmdVhJKPCuxT8aRP5ttM83vrVSV
         crDg3TdFQ7bB+dspDzSQfigvabNtVIVq0ne0yjly4KdHNp/T7u5EKJQLqlMhQMFWR1OG
         4m6hOLaPZDLM+xzyad7Y82w4mSwMeWmTkBV0E=
Message-ID: <b9df5fa10808061022r34e3a009k5060c8fab06bcd5c@mail.gmail.com>
Date: Wed, 6 Aug 2008 23:22:33 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: pj@sgi.com, menage@google.com
Subject: [PATCH] cpuset : Handling improper memory allocation.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure that , if kmalloc fails in
"rebuild_sched_domains", then we've a place to go. If anything else,
please let me know.

Thanks.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc2.orig/kernel/cpuset.c	2008-08-06 16:23:26.000000000 +0600
+++ linux-2.6.27-rc2/kernel/cpuset.c	2008-08-06 23:07:59.504441992 +0600
@@ -615,7 +615,8 @@ void rebuild_sched_domains(void)
 		if (dattr) {
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
-		}
+		} else
+			goto rebuild;
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
 	}
@@ -685,6 +686,8 @@ restart:
 	if (!doms)
 		goto rebuild;
 	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
+	if (!dattr)
+		goto rebuild;

 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
