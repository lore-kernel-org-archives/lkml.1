Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbXFTRbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbXFTRbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXFTRbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:31:25 -0400
Received: from www.osadl.org ([213.239.205.134]:47928 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755501AbXFTRbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:31:25 -0400
Subject: Re: [RFC] clocksouce implementation for powerpc
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>, Daniel Walker <dwalker@mvista.com>,
       Andrew Morton <akpm@osdl.org>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <467961F1.1060909@ru.mvista.com>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <20070616101637.107940593@inhelltoy.tec.linutronix.de>
	 <1182009083.11539.369.camel@imap.mvista.com>
	 <20070620065710.GR9768@bakeyournoodle.com>
	 <1182351439.18168.79.camel@imap.mvista.com>
	 <467961F1.1060909@ru.mvista.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 19:31:21 +0200
Message-Id: <1182360681.3316.25.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 21:20 +0400, Sergei Shtylyov wrote:
> >>+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
> >>+{
> >>+	timer_recalc_offset(tb_last_jiffy);
> >>+	timer_check_rtc();
> >>+}
> 
> > Hmm .. This doesn't look like it's taking into account that the time has
> > changed ..
> 
>     Why? By the time it gets called (form the timer softirq context) 

It is called from interrupt context at least in mainline. Only the -rt
patch moves this to the softirq.

	tglx


