Return-Path: <linux-kernel-owner+w=401wt.eu-S2993298AbXDTRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993298AbXDTRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767162AbXDTRbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:31:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993295AbXDTRbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:31:50 -0400
Date: Fri, 20 Apr 2007 10:30:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-Id: <20070420103052.686f3c71.akpm@linux-foundation.org>
In-Reply-To: <20070420122609.GA22325@in.ibm.com>
References: <20070419120131.GB13435@in.ibm.com>
	<200704201054.38037.rjw@sisk.pl>
	<20070420110520.GB11290@in.ibm.com>
	<200704201359.30490.rjw@sisk.pl>
	<20070420122609.GA22325@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 17:56:09 +0530
Gautham R Shenoy <ego@in.ibm.com> wrote:

> > I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN,
> > PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two more for
> > the freezer-based CPU hotplug, so if yet another one is needed, that will make
> > up almost a separate u8 field ...
> 
> I am perfectly ok with it. But I am not sure if everybody would agree to have
> another field in the task struct, though in this case it does make sense :-)

OK by me.  You might want to consider making that fields's locking protocol
be set_bit(), clear_bit(), etc rather than task_lock().
