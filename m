Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZERKEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZERKEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZERKEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:04:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:50624 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbZERKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:04:07 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: benh@kernel.crashing.org, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v1 PATCH 0/4] Add INT mode support for EDAC drivers on Maple
Date: Mon, 18 May 2009 18:04:56 +0800
Message-Id: <1242641100-15324-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 18 May 2009 10:03:50.0200 (UTC) FILETIME=[F120CB80:01C9D79F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ben,

This is the v2 patches that have integrated your suggestions to
remove the refcount for a hwriq2virq mapping as long as we don't
dispose it, the changes are mostly within the 1/4 patch where the
unnecessary refcount and irqmap structure are removed, and callings
to edac_put_mpic_irq() are also removed from the rest of patches.

Since there are 3 EDAC modules on Maple will use one same copy of
code to create hwirq2virq mappings, I perfer to preserve it in
edac_mpic_irq.c.

How do feel about the assumption that MPIC will latch INT 0 pin for 
the NMI Reqeust Messages whose vector is == 0? This is the thing that
I have least confidence in, so far all I can get is the brief
introduction in CPC925 user manual that "This interrupt vector is used
to set a corresponding interrupt latch", P111, so I think it imples that
vector==0 will latch pin #0.

Many thanks for all your comments!

Best regards,

Harry
