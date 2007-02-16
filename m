Return-Path: <linux-kernel-owner+w=401wt.eu-S1946324AbXBPX7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946324AbXBPX7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946325AbXBPX7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:59:49 -0500
Received: from mail.screens.ru ([213.234.233.54]:38653 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946324AbXBPX7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:59:49 -0500
Date: Sat, 17 Feb 2007 02:59:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070216235939.GB244@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216164730.GD21457@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> Note with the change proposed in refrigerator, we can avoid
> CPU_DEAD_KILL_THREADS and do all cleanup in CPU_DEAD itself.

In that case (all processes are frozen when workqueue_cpu_callback()
calls cleanup_workqueue_thread()) I agree, it is better to just use
kthread_stop/kthread_should_stop.

This also means that probably it won't be convenient to do this change
"by small steps" as I suggested before.

Oleg.

