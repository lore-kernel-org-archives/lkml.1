Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYJ3XBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYJ3XBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYJ3XAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:00:51 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:24585 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753022AbYJ3XAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:00:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2fePHTbEKDm0e7gddAw4557obpXKLsGTEPmLcHiCcZt4crDGRrukcXw87fQ6CPEjTQVVgOW2vdDJ3pk+0TC6EG3tushDyAIdEW6WMgLHLm/LqStnkFn55uqBibJSpWE9imNb+Nd5mJg6Ko97QbWY0Q8PhE0Pu4meRJWQ2FslQdI=  ;
X-YMail-OSG: .y6GDrUVM1k7rQJqdrPaF1I87mUdX6S3kCIxgn_hUGH4w2qDV9Ek_VOUQ81.tjM6dUTigbmxw8Z5lUv2YGbcfmU_basSpNkYpz_EkyAjjG_EfNoBXSgp1m.qJJE8FXloU0k4WIbGi9Jq0BJ6CIGhFlvmtnk2WZtQaKO0p3fkI50_qcoEY91R4_AcZygR
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.28-rc2] CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
Date: Thu, 30 Oct 2008 15:59:50 -0700
User-Agent: KMail/1.9.10
Cc: Roland McGrath <roland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810301559.50467.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Kernels that don't support ELF coredumps at all surely can't
be supporting new partial-segment flavored ELF coredumps ...
don't make folk answer Kconfig questions about that flavor.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Roland McGrath <roland@redhat.com>
---
 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -43,7 +43,7 @@ config BINFMT_ELF_FDPIC
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
 	default n
-	depends on BINFMT_ELF
+	depends on BINFMT_ELF && ELF_CORE
 	help
 	  ELF core dump files describe each memory mapping of the crashed
 	  process, and can contain or omit the memory contents of each one.
