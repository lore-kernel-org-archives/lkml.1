Return-Path: <linux-kernel-owner+w=401wt.eu-S967339AbXFHCkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967339AbXFHCkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966155AbXFHCkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:40:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966059AbXFHCkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:40:36 -0400
Date: Thu, 7 Jun 2007 19:39:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: Per container statistics (containerstats)
Message-Id: <20070607193917.c21f9071.akpm@linux-foundation.org>
In-Reply-To: <4668BD18.7090603@linux.vnet.ibm.com>
References: <20070606115813.GA32197@linux.vnet.ibm.com>
	<20070607155445.edd5fded.akpm@linux-foundation.org>
	<4668BD18.7090603@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 07:51:12 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > 
> > I'd have hoped to see containerstats.c in here.
> > 
> 
> The current statistics code is really small, so it fit into taskstats.c.
> May be in the future, we could re-factor it and move it out.

I was referring to your userspace tool which reads this stuff.  The one
which you described in the changelog.

> >> +	rcu_read_lock();
> >> +
> >> +	for_each_root(root) {
> >> +		if (!root->subsys_bits)
> >> +			continue;
> >> +		root_cont = &root->top_container;
> >> +		get_first_subsys(root_cont, NULL, &subsys_id);
> >> +		do_each_thread(g, p) {
> > 
> > this needs tasklist_lock?
> > 
> 
> rcu_read_lock() should be fine. From Eric's patch at
> 
> 2.6.17-mm2 - proc-remove-tasklist_lock-from-proc_pid_readdir.patch
> 
> The patch mentions that "We don't need the tasklist_lock to safely
> iterate through processes anymore."
> 

oh, OK.  rcu_read_lock() is the new lock_kernel() - always hard to tell
what it's locking.

