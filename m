Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYFAEad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYFAEad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 00:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYFAEaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 00:30:23 -0400
Received: from rel106.mail.aue.yahoo.com ([124.108.96.113]:20459 "HELO
	rel106.mail.aue.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750922AbYFAEaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 00:30:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 00:30:22 EDT
X-YMail-OSG: 2b20M2wVM1k7pVzffBgcy08CEe3BgWFusXtURhZ.rT8kYaeS0g.Zabf_M.2e2FjALQ--
X-Yahoo-Newman-Property: ymail-3
From: Keri Harris <keri@gentoo.org>
To: paulus@samba.org
Subject: [POWERPC] disabling CONFIG_BUG breaks kernel compile
Date: Sun, 1 Jun 2008 16:23:39 +1200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806011623.39656.keri@gentoo.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'make randconfig' of the latest linux-next on powerpc caught a buglet where
disabling CONFIG_BUG on powerpc breaks the kernel compile:

  CC      arch/powerpc/kernel/module_32.o
arch/powerpc/kernel/module_32.c: In function 'module_find_bug':
arch/powerpc/kernel/module_32.c:377: error: increment of pointer to unknown structure
arch/powerpc/kernel/module_32.c:377: error: arithmetic on pointer to an incomplete type
arch/powerpc/kernel/module_32.c:378: error: dereferencing pointer to incomplete type
make[1]: *** [arch/powerpc/kernel/module_32.o] Error 1

A quick grep of 'bug_entry' through the powerpc code seems to indicate this
also affects arch/powerpc/kernel/module_64.c and arch/powerpc/xmon.c.

Thanks,

Keri
