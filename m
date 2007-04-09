Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXDIFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXDIFyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXDIFyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:54:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:51031 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752966AbXDIFyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:54:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18jICwl0ukjtERNDCsVlrt7qO5wPM/ELIylbFF/pM
	JDuC3aF52hDx8b
Subject: Re: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0704081723y4d9e7263yc5e6a7451ffa7392@mail.gmail.com>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
	 <1175962840.10478.49.camel@Homer.simpson.net>
	 <1175966255.11408.5.camel@Homer.simpson.net>
	 <1176019324.8244.6.camel@Homer.simpson.net>
	 <b647ffbd0704081714j2af41daaq6643e187b7511b03@mail.gmail.com>
	 <b647ffbd0704081723y4d9e7263yc5e6a7451ffa7392@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 07:54:14 +0200
Message-Id: <1176098054.6355.100.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 02:23 +0200, Dmitry Adamushko wrote:
> > [...]
> > Well, it's a late hour, so maybe I'm missing something... but it does
> > look to be HZ and "will run" time interval related issue. Like
> > described in (*). Or maybe we both observe similar situations but have
> > different reasons behind them.
> 
> I meant that account_user_time() is also called from timer_ISR ->
> update_process_times() like scheduler_tick(). So if task's running
> intervals are shorter than 1/HZ, it's not always accounted --> so cpu%
> may be wrong for such a task...

I think you're right wrt percentages, and that's making accurate
measurement of SD fairness difficult.  However, total runtime for user
tasks should be pretty accurate for kernels that use nanoseconds,
because they're added every time a tasks passes through schedule().

BTW, the aberration I noticed with my unverified "testcase" does _seem_
to be repeatable here.  Once behavior changes, after a reboot the
repeatability returns.  I have no idea what's going on, but something is
sure fishy.

	-Mike

