Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYDNNsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYDNNsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbYDNNrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:47:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670AbYDNNro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:47:44 -0400
Date: Mon, 14 Apr 2008 09:46:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, nickpiggin@yahoo.com.au,
       k-miyoshi@cb.jp.nec.com, greg@kroah.com,
       Bernhard Walle <bwalle@suse.de>, kdb@oss.sgi.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>
Subject: Re: [PATCH 0/2] add new notifier function ,take3
Message-ID: <20080414134622.GB6941@redhat.com>
References: <47FF190B.6030406@ah.jp.nec.com> <20080411210751.e4a468b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411210751.e4a468b2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:07:51PM -0700, Andrew Morton wrote:

[..]
> > Kernel panic - not syncing: Panic by panic_module.
> > __tunable_atomic_notifier_call_chain enter
> > msg_handler:panic_event was called.
> > ipmi_wdog:wdog_panic_handler was called.
> > notifier_test: notifier_test_panic() is called.
> > notifier_test: notifier_test_panic2() is called.
> 
> OK.  But I don't see anywhere in here the most important piece of
> information: why do we need this feature in Linux?
> 
> What are the use-cases?  What is the value?  etc.
> 
> Often I can guess (but I like the originator to remove the guesswork).  In
> this case I'm stumped - I can't see any reason why anyone would want this.
> 

Hi Andrew,

To begin with, he wants kdb, kgdb etc to co-exist with kdump. He wants
to put all the RAS tools (who are interested in panic event) on a list
and export it to user space and let user decide in what order do the tool get
executed at panic time (based on priority).

This brings in little bit reliability concerns for kdump due to notifier
code being run after panic.

I think people want to use this infrastrutucure beyond RAS tools. I
remember somebody wanting to send a message to remote node after a
panic (before kdump kicks in)  so that remote node can initiate failover
etc.

Ideally, doing any operation after panic is not safe and one should avoid
such things and any action required should be done in next kernel (like
sending messages to remote nodes etc). Having said that, it makes the
job harder as one needs to pass all the required data to second kernel.

So it will not left to user whether he should execute the code after
panic in first kernel or create required bits to execute code in second
kernel. Things should be more reliable in second kernel. 

I am not very sure how paranoid one should be about this additional bit of
notifier code being executed after panic. Probably we can take this in
to make user's life easier.

Thanks
Vivek
