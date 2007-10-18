Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXJRGsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXJRGsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXJRGsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:48:14 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56693 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbXJRGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:48:12 -0400
Message-ID: <471700F4.1080200@ah.jp.nec.com>
Date: Thu, 18 Oct 2007 15:45:08 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: [PATCH 0/2] add new notifier function ,take2
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A big thanks to everybody who read and replied to first version. I have tried to
incorporate reviewer's comments and suggestions.

changelog take1 -> take2

- Rebased 2.6.23
- comment updated
- renamed the notifiner name "tunable_notifier" to "tunable_atomic_notifier"
- fixed typo


These patches add new notifier function and implement it to panic_notifier_list.
We used the hardcoded notifier chain so far, but it was not flexible. New
notifier is very flexible, because user can change a list of order by debugfs.

Thanks,

Example)

# cd /sys/kernel/debug/
# ls
kprobes  pktcdvd
# insmod ipmi_msghandler.ko
# ls
kprobes  panic_notifier_list  pktcdvd
# cd panic_notifier_list/
# ls
ipmi_msghandler
# insmod ipmi_watchdog.ko
# ls
ipmi_msghandler  ipmi_wdog
# cat ipmi_msghandler/priority
200
# cat ipmi_wdog/priority
150
#
Kernel panic - not syncing: panic
ipmi_msghandler : notifier calls panic_event().
ipmi_watchdog : notifier calls wdog_panic_handler().

.....(reboot)

# cat ipmi_msghandler/priority
200
# cat ipmi_wdog/priority
150
# echo 300 > ipmi_wdog/priority
#
Kernel panic - not syncing: panic
ipmi_watchdog : notifier calls wdog_panic_handler().
ipmi_msghandler : notifier calls panic_event().

--
Takenori Nagano <t-nagano@ah.jp.nec.com>
