Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXB1JKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXB1JKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXB1JKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:10:55 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36141 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXB1JKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:10:53 -0500
Date: Wed, 28 Feb 2007 14:40:53 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228091053.GA15509@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl> <20070228030726.GK29179@in.ibm.com> <20070228084859.GB104@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228084859.GB104@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 11:48:59AM +0300, Oleg Nesterov wrote:
> On 02/28, Srivatsa Vaddagiri wrote:
> > We can just thaw the worker thread selectively before kthread_stopping
> > them. This will let us freeze all worker threads (which we want to for
> > hotplug anyway).
> 
> I am not sure this is a good change for 2.6.21.

So we make that change when merging the freezer-based hotplug patchset?

> I strongly believe it is better to change XFS so that it doesn't use
> create_freezeable_workqueue() as Rafael suggested. 

Ok no issues. But when we enable freezer-based hotplug, we expect all
non-singlethreaded worker threads to be frozen (for hotplug atleast).

> Besides, freezeable workqueues are buggy anyway in 2.6.21-rc,
> 
> 	http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755
>
> This means that workqueues become non-freezeable after suspend/resume
> anyway (if I understand disable_nonboot_cpus() correctly).

Ah ok. When is the above patch expected to be merged?

-- 
Regards,
vatsa
