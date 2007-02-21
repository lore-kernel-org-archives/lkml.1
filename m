Return-Path: <linux-kernel-owner+w=401wt.eu-S1422638AbXBUPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422638AbXBUPxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXBUPxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:53:40 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41927 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161309AbXBUPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:53:38 -0500
Date: Wed, 21 Feb 2007 21:23:05 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070221155305.GB1596@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com> <20070216235939.GB244@tv-sign.ru> <20070217022940.GB25924@in.ibm.com> <20070217215928.GA563@tv-sign.ru> <20070220151220.GB4960@in.ibm.com> <20070220200936.GB85@tv-sign.ru> <20070221062947.GG20820@in.ibm.com> <20070221143010.GC134@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221143010.GC134@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 05:30:10PM +0300, Oleg Nesterov wrote:
> Agreed. Note that we don't need the new "del_work". It is always safe to
> use cancel_work_sync() if we know that the workqueue is frozen, it won't
> block. We can also do
> 
> 	if (!cancel_delayed_work())
> 		cancel_work_sync();
> 
> but it is ok to do cancel_work_sync() unconditionally.

Argh ..I should keep referring to recent sources. I didnt see
cancel_work_sync() in my sources (2.6.20-rc4) and hence invented that 
del_work()! Anyway thanx for pointing out.

This change will probably let us do CPU_DOWN_PREPARE after
freeze_processes(). However I will keep my fingers crossed on whether it
is really a good idea to send CPU_DOWN/UP_PREPARE after
freeze_processes() until we get more review/testing results.

-- 
Regards,
vatsa
