Return-Path: <linux-kernel-owner+w=401wt.eu-S1765179AbXGSVGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765179AbXGSVGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765580AbXGSVGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:06:42 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:30290 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762480AbXGSVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:06:40 -0400
Subject: Re: [PATCH] virtual sched_clock() for s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
In-Reply-To: <20070719193840.GA29523@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain>
	 <469F8342.7060000@goop.org> <20070719160025.GA31815@elte.hu>
	 <1184872821.5516.10.camel@localhost.localdomain>
	 <20070719193840.GA29523@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 21:07:03 +0000
Message-Id: <1184879223.5516.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 21:38 +0200, Ingo Molnar wrote: 
> * Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> 
> > > still, CFS needs time measurement across idle periods as well, for 
> > > another purpose: to be able to do precise task statistics for /proc. 
> > > (for top, ps, etc.) So it's still true that sched_clock() should 
> > > include idle periods too.
> > 
> > I'm not sure, s390 already has an implemetation for precise accounting 
> > in the architecture code, does CFS also improve accounting data?
> 
> what kind of precise accounting does s390 have in the architecture code? 
> CFS changes task (and load) accounting to be sched_clock() driven in 
> essence.

s390 has per-process accounting that is aware of virtual cpu time, implemented in
arch/s390/kernel/time.c: account_ticks() and arch/s390/kernel/vtime.c:
account_*_vtime(). Timestamps are taken in entry.S for system calls, interrupts
and other system entries and are accounted later, we don't call update_process_times().

Jan

> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

