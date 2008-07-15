Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbYGOCZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbYGOCZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYGOCZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:25:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYGOCZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:25:43 -0400
Message-ID: <487C0A74.4070903@jp.fujitsu.com>
Date: Tue, 15 Jul 2008 11:24:52 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com> <200807142234.40700.rusty@rustcorp.com.au> <487BA152.1070102@goop.org> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> Hmm.. probably a stupid question: but what could happen that a real cpu
> (not virtual) becomes unresponsive so that it won't schedule a MAX_RT_PRIO-1
> prioritized task for 5 seconds?

The original problem (once I heard and easily reproduced) was there was an
another MAX_RT_PRIO-1 task and the task was spinning in itself by a bug.
(Now this would not be a problem since RLIMIT_RTTIME will work for it, but
 I cannot deny that there are some situations which cannot set the limit.)

However there would be more possible problem in the world, ex. assume that
a routine work with interrupt (and also preemption) disabled have an issue
of scalability so it takes long time on huge machine then stop_machine will
stop whole system such long time.  You can assume a driver's bug.  Now the
stop_machine is good tool to escalate a partial problem to global suddenly.

>> So I think monotonic wallclock time actually makes the most sense here.
> 
> This is asking for trouble... a config option to disable this would be
> nice. But as I don't know which problem this patch originally addresses
> it might be that this is needed anyway. So lets see why we need it first.

I'm not good at VM etc., but I think user doesn't care who holds a cpu,
whether other guest or actual buggy software or space alien or so.
The important thing here is return control to user if timeout.

Thanks,
H.Seto
