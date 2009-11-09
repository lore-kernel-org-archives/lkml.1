Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZKIPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZKIPV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZKIPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:21:28 -0500
Received: from www.tglx.de ([62.245.132.106]:49298 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZKIPV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:21:28 -0500
Message-Id: <20091109150033.125758935@linutronix.de>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 15:21:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] Refactor spinlock inlining
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While moving preempt-rt to 2.6.32-rc I tripped over the spinlock
inlining changes and had a hard time to figure out when and which lock
function is inlined as the __always_inline__ defines are not directly
controlling the inlining because there are overrides depending on
various config options.

Merging the -rt modifications into this results in a horrible mess and
I tried to find a solution which simplifies the inlining decisions and
makes it more obvious when the decision is taken. 

To allow easier intergration of preempt-rt I reworked the inline
decision ifdeffery to be completely Kconfig based.

The result is slightly smaller in code lines, but adds a Kconfig file
which contains all the rules of inlining decisions. Architecturs can
select each locking function for inlining in the arch Kconfig instead
of defining __always_inline__*.

Thanks,

	tglx

