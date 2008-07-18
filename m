Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYGROm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYGROm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYGROmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:42:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:48050 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbYGROmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mcW2lHrnbWqKrPSrIi15skZZRevaEfaewYj7uCD/ESKppUr3V98IPGe28kNnplR5Vf
         JHDoli2kFJmmhqzZfA2j+dOPEiUBMG6wj6HbMhApq0OIrq6d929l+3cPDV81fjOzy009
         2VEdfdXqPwfw041eadHouGRUYEjQ6WnImvPRw=
Date: Fri, 18 Jul 2008 15:40:35 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: mingo@redhat.com
Subject: [Patch] vdso: check the value of vdso_enabled
Message-ID: <20080718144035.GA26261@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the value of 'vdso_enabled' is out of range, make it default.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: mingo@redhat.com

---
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0bce542..3428448 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -59,6 +59,8 @@ unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;
 static int __init vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
+	if (vdso_enabled > VDSO_COMPAT)
+		vdso_enabled = VDSO_DEFAULT;
 
 	return 1;
 }
