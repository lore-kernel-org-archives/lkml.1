Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYIWW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYIWW26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYIWW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:28:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:49471 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbYIWW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding:sender;
        b=UV19Mq2ft1jcOGQ1q1jDWr6hnzTT9CYaHSjXPxX0k48ZEQZUuvrk+Yqxt8GaZEqOt3
         oGCUsYIg6eq5Cq93JpHd5h56uveA3C2zfzGfok2hPrqx5NU9M3RBvxZTJTqSew7tNT4t
         jHVRcw/sx5pbzawnx+Elz7wZQzetdhSL2WXLg=
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/3] x86: export set_memory_ro() and set_memory_rw() calls
To: jeff@garzik.org, mingo@elte.hu, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 23 Sep 2008 15:28:48 -0700
Message-ID: <20080923222848.6281.23319.stgit@jtkirshe-mobile.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Export set_memory_ro() and set_memory_rw() calls needed by a follow-on
patch to the e1000e driver.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 arch/x86/mm/pageattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 43e2f84..0991e15 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -906,11 +906,13 @@ int set_memory_ro(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
 }
+EXPORT_SYMBOL(set_memory_ro);
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
 }
+EXPORT_SYMBOL(set_memory_rw);
 
 int set_memory_np(unsigned long addr, int numpages)
 {

