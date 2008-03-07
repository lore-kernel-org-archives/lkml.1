Return-Path: <linux-kernel-owner+w=401wt.eu-S1763856AbYCGNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763856AbYCGNCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYCGNC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:02:27 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:3685 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbYCGNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dJAYucvWzqZS1V1J4C3ksMGQ7J0eXTNvkdJXUs5swj5gCkLmUwKzCJwdh3vRvdZQQ0iSZhdnHWCM5I3urfkQC6/V4+7fet9buowEKsITEDdhGt3kBk2m61LDwfabaSV3qFkG+3jJzmn6JI9Mahwke4I61nHmV9okfruHlBmWWmY=
Message-ID: <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
Date: Fri, 7 Mar 2008 14:02:20 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: ego@in.ibm.com, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>, "Yi Yang" <yi.y.yang@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080307105138.GA10576@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <20080303153154.GA11288@in.ibm.com>
	 <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
	 <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru>
	 <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru>
	 <20080307091049.GA8827@in.ibm.com> <20080307105138.GA10576@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

'watchdog' is of SCHED_FIFO class. The standard load-balancer doesn't
move RT tasks between cpus anymore and there is a special mechanism in
scher_rt.c instead (I think, it's .25 material).

So I wonder, whether __migrate_task() is still capable of properly
moving a RT task to another CPU (e.g. for the case when it's in
TASK_RUNNING state) without breaking something in the rt migration
mechanism (or whatever else) that would leave us with a runqueue in
the 'inconsistent' state...
(I've taken a quick look at the relevant code so can't confirm it yet)

maybe it'd be faster if somebody could do a quick test now with the
following line commented out in kernel/softlockup.c :: watchdog()

-         sched_setscheduler(current, SCHED_FIFO, &param);


-- 
Best regards,
Dmitry Adamushko
