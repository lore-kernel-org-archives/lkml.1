Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbXB1DBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbXB1DBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 22:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXB1DBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 22:01:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56171 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbXB1DBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 22:01:08 -0500
Date: Wed, 28 Feb 2007 08:31:13 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228030113.GJ29179@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702272251.28844.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 10:51:27PM +0100, Rafael J. Wysocki wrote:
> We have a problem with freezable workqueues in 2.6.21-rc1 and in -mm
> (there are only two of them, in XFS, but still).  Namely, their worker threads
> deadlock with workqueue_cpu_callback() that gets called during the CPU hotplug,
> becuase workqueue_cpu_callback() tries to stop these threads while they are
> frozen (disable_nonboot_cpus() happens after we've frozen tasks).

This problem (of kthread_stopping a frozen thread) was there when we
implemented freezer-based cpu hotplug. We worked around that in the
callbacks by thawing the worker thread first before kthread_stopping it,
which is working pretty neatly.

Should that fix the issue? 

-- 
Regards,
vatsa
