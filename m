Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXFZNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXFZNXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 09:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXFZNXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 09:23:45 -0400
Received: from webmailfront02.ispgateway.de ([80.67.16.112]:40678 "EHLO
	webmailfront02.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbXFZNXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 09:23:44 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 09:23:43 EDT
Message-ID: <20070626150323.anz74r8q8s408s4o@webmail.df.eu>
Date: Tue, 26 Jun 2007 15:03:23 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> so how about the following, different approach: anyone who has a tasklet
> in any performance-sensitive codepath, please yell now.

ALSA uses quite a few tasklets in the framework and in several  
drivers.  Since we
care very much about low latency, many places use tasklet_hi_*.

It would be possible to convert to some GENERIC_SOFTIRQ mechanism, but  
then we'd
want to use a softirq that has higher priority than the 'standard' generic
softirq, similar to HI_SOFTIRQ vs. TASKLET_SOFTIRQ.

BTW: Is there a reason why HRTIMER_SOFTIRQ is the lowest-priority  
softirq instead
of being near TIMER_SOFTIRQ?


Regards,
Clemens

