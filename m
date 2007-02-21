Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbXBUOyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbXBUOyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXBUOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:54:08 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33054 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXBUOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:54:05 -0500
Date: Wed, 21 Feb 2007 20:22:21 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070221145221.GB21660@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702151431.10068.rjw@sisk.pl> <20070215142542.GA14931@in.ibm.com> <200702171224.46626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702171224.46626.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,
On Sat, Feb 17, 2007 at 12:24:45PM +0100, Rafael J. Wysocki wrote:
> 
> Pavel, do you think we can remove the PF_NOFREEZE from bluetooth, BTW?

The create_workqueue by default marks the worker_threads to be
non_freezable. For cpu hotplug, all workqueues can be frozen 
except the "kthread" workqueue (which is single threaded, so won't 
be frozen anyway).

And a quick cscope scan shows that only the "xfslogd" and "xfsdatad"
are the only freezable workqueues. Any particular reason
for not marking rest of the non-single_threaded workqueues freezeable ??

thanks and regards
gautham
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
