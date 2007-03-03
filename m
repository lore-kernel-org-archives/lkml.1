Return-Path: <linux-kernel-owner+w=401wt.eu-S1030265AbXCCO00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265AbXCCO00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030275AbXCCO00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:26:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030265AbXCCO0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:26:25 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29317.1172931029@redhat.com> 
References: <29317.1172931029@redhat.com>  <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> 
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: [PATCH] NOMMU: Hide vm_mm in NOMMU mode
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 03 Mar 2007 14:25:58 +0000
Message-ID: <30055.1172931958@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Howells <dhowells@redhat.com>

Hide struct vm_area_struct::vm_mm when in NOMMU mode as this isn't used there.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 60e0e4a..ba394e7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -58,7 +58,9 @@ extern int sysctl_legacy_va_layout;
  * library, the executable area etc).
  */
 struct vm_area_struct {
+#ifdef CONFIG_MMU
 	struct mm_struct * vm_mm;	/* The address space we belong to. */
+#endif
 	unsigned long vm_start;		/* Our start address within vm_mm. */
 	unsigned long vm_end;		/* The first byte after our end address
 					   within vm_mm. */
