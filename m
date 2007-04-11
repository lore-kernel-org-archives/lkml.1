Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXDKLWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXDKLWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXDKLWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:22:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44523 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXDKLWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:22:32 -0400
Date: Wed, 11 Apr 2007 16:51:05 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-ID: <20070411112105.GA24813@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com> <20070411000316.52f2551e.akpm@linux-foundation.org> <200704111213.35523.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704111213.35523.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:13:34PM +0200, Rafael J. Wysocki wrote:
> 
> It should be calling try_to_freeze() somewhere anyway.  We may need to freeze
> all tasks in some cases.

How about
for (;;) {
	try_to_freeze();

?

This change allows us to make all the worker threads freezeable by default.
>From cpu-hotplug perspective, helper_wq was the only singlethreaded
non-freezeable workqueue.

> 
> Greetings,
> Rafael
> -

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
