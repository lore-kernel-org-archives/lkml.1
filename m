Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbXJJQEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbXJJQEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbXJJQDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:03:55 -0400
Received: from postmark.cse.wustl.edu ([128.252.166.5]:58998 "EHLO
	mail.cse.wustl.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbXJJQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:03:54 -0400
X-Greylist: delayed 1821 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 12:03:54 EDT
To: linux-kernel@vger.kernel.org
Subject: 2.6.23 spinlock hang in kswapd under heavy disk write loads
Message-Id: <20071010153332.71479CECBD@tamarack.cse.wustl.edu>
Date: Wed, 10 Oct 2007 10:33:32 -0500 (CDT)
From: berkley@cse.wustl.edu (Berkley Shands)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23 with CONFIG_DEBUG_SPINLOCK on does not hang under very high write loads
to either an LSI8888ELP (write rate 1.1GB/Sec) or to a highpoint RR2340 (write rate 1.0GB/Sec).
With CONFIG_DEBUG_SPINLOCK off however, the system hangs with kswapd getting
100% of the cpu and most if not all other processes are locked out. Sometimes even the
keyboard is locked out.

This is seen on a supermicro H8DM3-2 and H8DMi-2 motherboards, 16 GB RAM, 2222 SE or 2216 processors.
Not seen on a Uniwide 3546ES, or on a Supermicro H8DM8 with 8222 CPUS.

kswapd sits at (according to KDB)
__spinlock_irqsave + 0x15
prepare_to_wait + 0x15
kswapd + 0xe3
kthread + 0x47

berkley
