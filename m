Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbXJDLnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbXJDLnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbXJDLkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:40:32 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34793 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761424AbXJDLka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:40:30 -0400
Message-ID: <4704D09D.6080503@ah.jp.nec.com>
Date: Thu, 04 Oct 2007 20:38:05 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: vgoyal@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: [PATCH 0/2] add new notifier function
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add new notifier function and implement it to panic_notifier_list.
We used the hardcoded notifier chain so far, but it was not flexible. New
notifier is very flexible, because user can change a list of order by debugfs.

Please review, and give some comments.

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


