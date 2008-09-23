Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYIWWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYIWWau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYIWWai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:30:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:51136 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYIWWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding:sender;
        b=uyy14OzCxU5U2TYoY2Q3Kd/4/O7roGZJcaTFh7uH7GTSjYrRLMY7OXSShHJlpTLzIW
         j/SfX6gyGvHp6BQtuj471w7lT+RUn52x6fUY7/O6wWHbQJDPjwtnd98X+8r5WtpVE//J
         YXk4mczuwWixpR24JsPgslJ+n/bIEwXqfEhxQ=
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 1/3] x86: export set_memory_ro() and set_memory_rw() calls
To: jeff@garzik.org, mingo@elte.hu, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 23 Sep 2008 15:30:42 -0700
Message-ID: <20080923223042.6448.30999.stgit@jtkirshe-mobile.jf.intel.com>
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

