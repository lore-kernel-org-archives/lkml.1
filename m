Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXKSJV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXKSJV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXKSJVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:21:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbXKSJVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:21:20 -0500
Date: Mon, 19 Nov 2007 01:21:19 -0800 (PST)
Message-Id: <20071119.012119.118043374.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, jeremy@goop.org, gregkh@suse.de
Subject: regression from softlockup fix
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changeset:

commit 436e61d93605a3a36902c9ee510b0ecba0d7d361
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Oct 16 23:18:38 2007 -0700

    fix the softlockup watchdog to actually work
 ...

Causes my SMP niagara systems to trigger the softlockup message
frequently when the nohz timer fires.

The backtrace is always in the timer handler, the cpu is not
wedged at all, which makes me think it's likely triggering
erroneously.

I suspect that what is happening is that the NOHZ period is
longer than the softlockup timeout (10 seconds) and we get
an interrupt before the watchdog thread gets onto the cpu.

I'll happily test any suggested fix for this bug, thanks!
