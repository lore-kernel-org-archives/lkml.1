Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXD1F6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXD1F6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161143AbXD1F6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:58:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9537 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbXD1F62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:58:28 -0400
X-IronPort-AV: i="4.14,464,1170662400"; 
   d="scan'208"; a="141745438:sNHT45121167"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
X-Message-Flag: Warning: May contain useful information
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 27 Apr 2007 22:58:26 -0700
In-Reply-To: <20070427221803.2a117c23.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 27 Apr 2007 22:18:03 -0700")
Message-ID: <adak5vxm459.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 05:58:27.0024 (UTC) FILETIME=[3D342D00:01C7895A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
 > 23286:+ BUILD_BUG_ON(BCM43xx_SEC_KEYSIZE < ETH_ALEN);

BTW, I missed this before -- BUILD_BUG_ON() is actually far better
than WARN_ON(), I think.

Maybe something like this?  (Although someone who knows perl probably
has a better way)

---
Don't tell people to change BUILD_BUG_ON() to WARN_ON().

Signed-off-by: Roland Dreier <rolandd@cisco.com>

--- checkpatch.pl.orig	2007-04-27 20:30:34.000000000 -0700
+++ checkpatch.pl	2007-04-27 22:54:42.000000000 -0700
@@ -123,7 +123,7 @@
 	$warnings += search(qr/kernel_thread\(/, "Use kthread abstraction instead of kernel_thread()\n");
 	$warnings += search(qr/typedef/, "Do not add new typedefs.\n");
 	$warnings += search(qr/uint32_t/, "Incorrect type usage for kernel code. Use __u32 etc.\n");
-	$warnings += search(qr/BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");
+	$warnings += search(qr/(?<!BUILD_)BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");
 
 	# pedantic: Noisy regexps that aren't really fatal.
 	if ($opt_pedantic) {
