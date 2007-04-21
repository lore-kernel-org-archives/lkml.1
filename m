Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDUTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDUTyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXDUTyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:54:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59847 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXDUTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:54:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dean Nelson <dcn@americas.sgi.com>, Jes Sorensen <jes@americas.sgi.com>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, rja@sgi.com
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969574439-git-send-email-ebiederm@xmission.com>
	<20070419165103.5b671b28.akpm@linux-foundation.org>
	<46285C6B.7080101@sgi.com>
	<20070420142140.GB17368@lnx-holt.americas.sgi.com>
Date: Sat, 21 Apr 2007 13:53:20 -0600
In-Reply-To: <20070420142140.GB17368@lnx-holt.americas.sgi.com> (Robin Holt's
	message of "Fri, 20 Apr 2007 09:21:40 -0500")
Message-ID: <m1mz11ijwv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> I think this was originally coded with daemonize to avoid issues with
> reaping children.  Dean Nelson can correct me if I am wrong.  I assume
> this patch is going in as part of the set which will make these threads
> clear themselves from the children list and if that is the case, I can
> see no issues.

One of my earlier patches guarantees that kthreadd will have pid == 2.

daemonize actually explicitly reparents to init so using daemonize and
kernel_thread provides no help at all with respect to scaling.  It in
fact guarantees you will be on init's list of child processes.

The work to enhance wait is a little tricky and it conflicts with the
utrace patches, which makes it hard to pursue at the moment.

I'm actually sorting out kthread stop so I can complete the pid namespace.
But since all kthreads are children of kthreadd this helps in a small
way with the scaling issue.

Eric
