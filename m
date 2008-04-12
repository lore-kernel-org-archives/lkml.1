Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYDLEI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYDLEI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 00:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYDLEIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 00:08:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbYDLEIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 00:08:50 -0400
Date: Fri, 11 Apr 2008 21:07:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, kdb@oss.sgi.com, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, nickpiggin@yahoo.com.au,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com
Subject: Re: [PATCH 0/2] add new notifier function ,take3
Message-Id: <20080411210751.e4a468b2.akpm@linux-foundation.org>
In-Reply-To: <47FF190B.6030406@ah.jp.nec.com>
References: <47FF190B.6030406@ah.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 16:53:47 +0900 Takenori Nagano <t-nagano@ah.jp.nec.com> wrote:

> Hi,
> 
> A big thanks to everybody who read and replied to previous version.
> 
> changelog take2 -> take3
> 
> - Rebased 2.6.25-rc8-mm1
> - comment updated
> - renamed the notifiner name "tunable_notifier" to "tunable_atomic_notifier"
> - fixed typo
> - move control files debugfs to /sys/kernel
> 
> These patches add new notifier function and implement it to panic_notifier_list.
> We used the hardcoded notifier chain so far, but it was not flexible. New
> notifier is very flexible, because user can change a list of order by control files.
> 
> Example)
> 
> # cd /sys/kernel/notifiers/
> # ls
> panic_notifier_list
> # cd panic_notifier_list/
> # ls
> ipmi_msghandler  ipmi_wdog
> # insmod notifier_test.ko
> # ls
> ipmi_msghandler  ipmi_wdog  notifier_test1  notifier_test2
> # cat */priority
> 200
> 150
> 500
> 1000
> Kernel panic - not syncing: Panic by panic_module.
> __tunable_atomic_notifier_call_chain enter
> notifier_test: notifier_test_panic2() is called.
> notifier_test: notifier_test_panic() is called.
> msg_handler:panic_event was called.
> ipmi_wdog:wdog_panic_handler was called.
> 
> .....(reboot)
> 
> # cd /sys/kernel/notifiers/panic_notifier_list/
> # ls
> ipmi_msghandler  ipmi_wdog  notifier_test1  notifier_test2
> # cat */priority
> 200
> 150
> 500
> 1000
> # echo 10000 > ipmi_msghandler/priority
> # echo 5000 > ipmi_wdog/priority
> # echo 3000 > notifier_test1/priority
> # echo 1500 > notifier_test2/priority
> # cat */priority
> 10000
> 5000
> 3000
> 1500
> Kernel panic - not syncing: Panic by panic_module.
> __tunable_atomic_notifier_call_chain enter
> msg_handler:panic_event was called.
> ipmi_wdog:wdog_panic_handler was called.
> notifier_test: notifier_test_panic() is called.
> notifier_test: notifier_test_panic2() is called.

OK.  But I don't see anywhere in here the most important piece of
information: why do we need this feature in Linux?

What are the use-cases?  What is the value?  etc.

Often I can guess (but I like the originator to remove the guesswork).  In
this case I'm stumped - I can't see any reason why anyone would want this.

Awaiting enlightenment ;)

Thanks.
