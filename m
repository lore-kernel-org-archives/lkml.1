Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYHCJGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYHCJGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 05:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYHCJGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 05:06:16 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:57445 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYHCJGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 05:06:15 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Opteron Rev E has a bug ... a locked  instruction doesn't act as a read-acquire barrier
Date: Sun, 3 Aug 2008 11:06:12 +0200
User-Agent: PLD Linux KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808031106.12366.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/atomicops-internals-x86.cc
says

"  // Opteron Rev E has a bug in which on very rare occasions a locked
  // instruction doesn't act as a read-acquire barrier if followed by a
  // non-locked read-modify-write instruction.  Rev F has this bug in 
  // pre-release versions, but not in versions released to customers,
  // so we test only for Rev E, which is family 15, model 32..63 inclusive.
  if (strcmp(vendor, "AuthenticAMD") == 0 &&       // AMD
      family == 15 &&
      32 <= model && model <= 63) {
    AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = true;
  } else {
    AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = false;
  }
"

does kernel have quirk/workaround for this? I'm looking at arch/x86/kernel/cpu 
but I don't see workaround related to this (possibly I'm overlooking).

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
