Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZLLJj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZLLJj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbZLLJj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:39:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40672
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760669AbZLLJj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:39:56 -0500
Date: Sat, 12 Dec 2009 01:40:02 -0800 (PST)
Message-Id: <20091212.014002.173528710.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: RCU detected CPU 0 stall after panic on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee>
References: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Sat, 12 Dec 2009 10:54:19 +0200 (EET)

> I tried 2.6.32 git gaad3bf0 on a SMP sparc64 machine (Ultra Enterprise 
> 250). For some reason my disks were not found (not important in this 
> bugreport) and this resulted in panic (cannnot mount root). However, the 
> machine kept going and got the below messages (RCU detected CPU 0 stall 
> (t=1000 jiffies)) from timer interrupts.
> 
> This seems to be like a bug in RCU vs panic.

It's normal actually.  A panic() just loops forever and the cpu never
goes through an RCU grace period again as a result, and this triggers
the debugging timer that detects this condition.

Probably the panic() code should disable that assertion check.
