Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbYCLBDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbYCLBDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYCLBDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:03:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:38506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYCLBDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LWrhVVRlNGty+4kgSumb2joq62IlczSPVdiquhwImlnpbPDORIppA+VOARv/DtsLNGsap9n1AV5u4gci57KlSlLKKwp3JMPcZN1CpO6nP3qmFE7jkJ8LpsGeOcSD/FDxWo8CpRISojsHOmcESZkoi1n0w3UHuWpWBN+NN2DlRsY=
Date: Wed, 12 Mar 2008 09:09:33 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       paulmck@linux.vnet.ibm.com
Subject: [PATCH -mm] do not check condition twice in WARN_ON_SECS
Message-ID: <20080312010933.GA2957@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't check condition twice, change WARN_ON(condition) to WARN_ON(1)
Thanks Marcin Slusarz <marcin.slusarz@gmail.com> for pointing out

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/asm-generic/bug.h |    3 ++-
1 file changed, 2 insertions(+), 1 deletion(-)

diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
--- linux/include/asm-generic/bug.h	2008-03-12 08:45:08.000000000 +0800
+++ linux.new/include/asm-generic/bug.h	2008-03-12 09:04:07.000000000 +0800
@@ -80,7 +80,8 @@ extern void warn_on_slowpath(const char 
 	int __ret_warn_on = !!(condition);			\
 	if (unlikely(__ret_warn_on))				\
 		if (__ratelimit(secs * HZ, 1))			\
-			WARN_ON(condition);			\
+			WARN_ON(1);				\
+	unlikely(__ret_warn_on);				\
 })
 
 #ifdef CONFIG_SMP
