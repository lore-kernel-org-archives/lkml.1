Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbXJRHlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbXJRHlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761388AbXJRHlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:41:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60613 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761334AbXJRHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:32 -0400
Date: Thu, 18 Oct 2007 00:06:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function ,take2
Message-Id: <20071018000651.35b26e42.akpm@linux-foundation.org>
In-Reply-To: <471700F4.1080200@ah.jp.nec.com>
References: <471700F4.1080200@ah.jp.nec.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 15:45:08 +0900 Takenori Nagano <t-nagano@ah.jp.nec.com> wrote:

> Hi,
> 
> A big thanks to everybody who read and replied to first version. I have tried to
> incorporate reviewer's comments and suggestions.
> 
> changelog take1 -> take2
> 
> - Rebased 2.6.23
> - comment updated
> - renamed the notifiner name "tunable_notifier" to "tunable_atomic_notifier"
> - fixed typo
> 
> 
> These patches add new notifier function and implement it to panic_notifier_list.
> We used the hardcoded notifier chain so far, but it was not flexible. New
> notifier is very flexible, because user can change a list of order by debugfs.
> 
> Thanks,
> 
> Example)
> 
> # cd /sys/kernel/debug/
> # ls
> kprobes  pktcdvd
> # insmod ipmi_msghandler.ko
> # ls
> kprobes  panic_notifier_list  pktcdvd
> # cd panic_notifier_list/
> # ls
> ipmi_msghandler
> # insmod ipmi_watchdog.ko
> # ls
> ipmi_msghandler  ipmi_wdog
> # cat ipmi_msghandler/priority
> 200
> # cat ipmi_wdog/priority
> 150
> #
> Kernel panic - not syncing: panic
> ipmi_msghandler : notifier calls panic_event().
> ipmi_watchdog : notifier calls wdog_panic_handler().
> 
> .....(reboot)
> 
> # cat ipmi_msghandler/priority
> 200
> # cat ipmi_wdog/priority
> 150
> # echo 300 > ipmi_wdog/priority
> #
> Kernel panic - not syncing: panic
> ipmi_watchdog : notifier calls wdog_panic_handler().
> ipmi_msghandler : notifier calls panic_event().

I can sort-of see what this is doing.  Runtime-definable management of
which notifier functions will be called on a panic?  Or maybe I
misunderstood.

But even if I did understand, I don't understand why Linux needs this
feature - what are the use cases, what is the value to our users?

Can you please flesh that information out a bit more?

The patches are somewhat wordwrapped - please check your email client
configuration, thanks.
