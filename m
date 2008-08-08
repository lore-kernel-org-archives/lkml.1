Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYHHUqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYHHUqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYHHUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:46:25 -0400
Received: from gw.goop.org ([64.81.55.164]:34767 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYHHUqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:46:25 -0400
Message-ID: <489CB08F.9030902@goop.org>
Date: Fri, 08 Aug 2008 13:46:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mark McLoughlin <markmc@redhat.com>, xen-devel@lists.xensource.com,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH] x86: work around gcc 3.4.x bug
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org>	<20080808080155.GA1992@cs181140183.pp.htv.fi>	<489C6485.7050009@goop.org>	<20080808161331.GF14495@cs181140183.pp.htv.fi>	<489C89FA.5000301@goop.org> <20080808183711.GA14495@cs181140183.pp.htv.fi>
In-Reply-To: <20080808183711.GA14495@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-3.4.x crashes when compiling pgd_prepopulate_pmd() when
PREALLOCATED_PMDS == 0 and CONFIG_DEBUG_INFO is enabled.  This seems
to avoid the problem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 arch/x86/mm/pgtable.c |    3 +++
 1 file changed, 3 insertions(+)

===================================================================
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -207,6 +207,9 @@
 	unsigned long addr;
 	int i;
 
+	if (PREALLOCATED_PMDS == 0) /* Work around gcc-3.4.x bug */
+		return;
+
 	pud = pud_offset(pgd, 0);
 
  	for (addr = i = 0; i < PREALLOCATED_PMDS;


