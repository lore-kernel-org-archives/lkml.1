Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJQFhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJQFhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYJQFhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:37:32 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:42106 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYJQFhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:37:31 -0400
Message-ID: <48F82481.8070201@nortel.com>
Date: Thu, 16 Oct 2008 23:37:05 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org>
In-Reply-To: <20081016181452.GA29739@yoda.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2008 05:37:07.0123 (UTC) FILETIME=[64904830:01C9301A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:

 > Are these two merged yet?  I just spent the better part of the morning
 > trying to figure out why various Fedora kernels based on 2.6.27-rcX and
 > 2.6.27 final hung on my G5 and finally got one booting with FTRACE
 > disabled.

Until recently I could boot my G5 with FTRACE enabled, but it totally screwed 
up load balancing.

As of a couple days ago, -tip hung on boot due to the following genirq 
issue:


diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 570d1ea..1c178ae 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -132,7 +132,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
    		return 0;

    	spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, flags);
+	ret = __irq_set_trigger(desc, irq, type);
    	spin_unlock_irqrestore(&desc->lock, flags);
    	return ret;
    }



Chris

