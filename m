Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZDFHCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZDFHCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZDFHCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:02:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50787 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZDFHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vHiFva001KceqpYXcar/l3QLJLtX68DJpqdmg4S7+MFBVChjUfPLz4zGDcfXAXdKHc
         ar+dnwFYDoKkVcZn6NgOeXuMpwVxa+PexQUayD8aD5c7wr+DtExnmdvlOxJ1KzLkbPth
         2tOOAkoOOc61zoxM8249ovuL0KGGEDo9rdNko=
Date: Mon, 6 Apr 2009 11:01:52 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, kees@ubuntu.com
Subject: [PATCH next] sysctl: fix build breakage
Message-ID: <20090406070152.GA29032@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when MODULES is not set:
kernel/sysctl.c:545: error: 'one' undeclared here

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4a0f8ad..655762b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -91,7 +91,7 @@ extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
-#if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+#if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM) || defined(CONFIG_MODULES)
 static int one = 1;
 #endif
 #ifdef CONFIG_DETECT_SOFTLOCKUP
