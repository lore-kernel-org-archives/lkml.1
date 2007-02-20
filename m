Return-Path: <linux-kernel-owner+w=401wt.eu-S964986AbXBTPMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986AbXBTPMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965021AbXBTPMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:12:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45551 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986AbXBTPMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:12:42 -0500
Date: Tue, 20 Feb 2007 20:42:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070220151220.GB4960@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com> <20070216235939.GB244@tv-sign.ru> <20070217022940.GB25924@in.ibm.com> <20070217215928.GA563@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215928.GA563@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 12:59:28AM +0300, Oleg Nesterov wrote:
> Before you begin. You are doing CPU_DOWN_PREPARE after freeze_processes().
> Not good. This makes impossible to do flush_workueue() at CPU_DOWN_PREPARE
> stage, we have callers.

We have few solutions to deal with this:

a. Mark such workqueues not freezable for hotplug
b. If above is not possible, don't call flush_workqueue in DOWN_PREPARE
c. If above is not possible, send DOWN_PREPARE before freeze_processes()

I would prefer a solution in the above order listed.

Which caller are you referring to here? Maybe we can decide on the
option after we see the users of flush_workqueue() in DOWN_PREPARE.

> I'm afraid it won't be so easy to solve all locking/racing problems. Will
> wait for the patch :)

I dont see problems for workqueue.c even if we follow option c. Do you
see any?

-- 
Regards,
vatsa
