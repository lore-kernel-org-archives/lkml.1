Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbXB1It3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbXB1It3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXB1It2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:49:28 -0500
Received: from mail.screens.ru ([213.234.233.54]:60718 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXB1It2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:49:28 -0500
Date: Wed, 28 Feb 2007 11:48:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228084859.GB104@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl> <20070228030726.GK29179@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228030726.GK29179@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 28, 2007 at 12:57:35AM +0100, Rafael J. Wysocki wrote:
> > > How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?
> > 
> > They all are PF_NOFREEZE, I suppose.  If we make all workqueues nonfreezable
> > (as they were before), the problem won't appear.
> 
> We can just thaw the worker thread selectively before kthread_stopping
> them. This will let us freeze all worker threads (which we want to for
> hotplug anyway).

I am not sure this is a good change for 2.6.21.

I strongly believe it is better to change XFS so that it doesn't use
create_freezeable_workqueue() as Rafael suggested. Besides, freezeable
workqueues are buggy anyway in 2.6.21-rc,

	http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755

This means that workqueues become non-freezeable after suspend/resume
anyway (if I understand disable_nonboot_cpus() correctly).

Oleg.

