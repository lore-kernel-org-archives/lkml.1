Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbXJUF66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbXJUF66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 01:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXJUF6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 01:58:51 -0400
Received: from mtoichi16.ns.itscom.net ([219.110.2.186]:64999 "EHLO
	mtoichi16.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXJUF6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 01:58:50 -0400
Date: Sun, 21 Oct 2007 14:58:17 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pavel@suse.cz
Subject: mysqld prevents s2ram [Re: 2.6.23-mm1]
Message-ID: <20071021055816.GA4204@inferi.kami.home>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/

Ok, now that it boots let's go for more.

I cannot suspend if mysqld is running. mysql isn't atually doing
anything useful anyway.
This is the failed suspend tasks dump of mysql:
[    0.000000] Linux version 2.6.23-mm1-1 (mattia@tadamune) (gcc version 4.2.1 (Debian 4.2.1-3)) #5 SMP PREEMPT Sun Oct 21 13:50:54 JST 2007
...
[  271.736214] PM: Preparing system for mem sleep
[  271.738185] Freezing user space processes ... 
[  291.918090] Freezing of tasks failed after 20.19 seconds (1 tasks refusing to freeze):
[  291.918156]   task                PC stack   pid father
...
[  292.043105]  =======================
[  292.043175] mysqld_safe   D c03d40c0     0  2393      1
[  292.043343]        c26b3eac 00000082 c03d0eb0 c03d40c0 c011a850 c011a843 c2626aa0 c2626bd4 
[  292.043803]        c17fd0c0 00000000 c26b3e88 c26cc380 c26b3ea8 c011b83a c26b3ea0 00000000 
[  292.044322]        08104d08 00000000 00000000 08104d08 00000000 c26b3eb8 c0141de0 c26b3fb8 
[  292.044843] Call Trace:
[  292.044969]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.045091]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.045214]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.045335]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.045456]  =======================
[  292.045524] mysqld        D c03d40c0     0  2430   2393
[  292.045692]        c25d0eac 00000086 c03d0eb0 c03d40c0 c0119eb5 00000000 c1c98550 c1c98684 
[  292.046184]        c18060c0 00000001 c25d0e88 c2603000 c25d0ea8 c011b83a c25d0ea0 00000000 
[  292.046705]        00000000 00000000 00000000 00000000 00000000 c25d0eb8 c0141de0 c25d0fb8 
[  292.047272] Call Trace:
[  292.049112]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.049234]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.049357]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.049477]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.049598]  =======================
[  292.049666] mysqld        D c03d40c0     0  2433   2393
[  292.049834]        c3000eac 00000086 c03d0eb0 c03d40c0 00000000 00000000 c1c98aa0 c1c98bd4 
[  292.050306]        c17fd0c0 00000000 c3000e88 c2603000 c3000ea8 c011b83a c3000ea0 00000000 
[  292.050827]        00000000 00000001 00000000 00000000 00000001 c3000eb8 c0141de0 c3000fb8 
[  292.051353] Call Trace:
[  292.051479]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.051599]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.051721]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.051842]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.051962]  =======================
[  292.052031] mysqld        D c03d40c0     0  2434   2393
[  292.052198]        c27b6eac 00000086 c03d0eb0 c03d40c0 c02d95a9 c27b6e8c c1d76aa0 c1d76bd4 
[  292.052660]        c17fd0c0 00000000 c27b6e88 c2603000 c27b6ea8 c011b83a c27b6ea0 00000000 
[  292.053179]        00000000 00000007 00000000 00000000 00000007 c27b6eb8 c0141de0 c27b6fb8 
[  292.053699] Call Trace:
[  292.053825]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.053958]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.054081]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.054203]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.054323]  =======================
[  292.054392] mysqld        D c03d40c0     0  2435   2393
[  292.054560]        c26b2eac 00000086 c03d0eb0 c03d40c0 c0119eb5 00000000 c1c42ff0 c1c43124 
[  292.055028]        c18060c0 00000001 c26b2e88 c2603000 c26b2ea8 c011b83a c26b2ea0 00000000 
[  292.055548]        00000000 00000013 00000000 00000000 00000013 c26b2eb8 c0141de0 c26b2fb8 
[  292.056087] Call Trace:
[  292.056214]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.056335]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.056458]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.056579]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.056700]  =======================
[  292.056769] mysqld        D c03d40c0     0  2436   2393
[  292.056937]        c2776eac 00000086 c03d0eb0 c03d40c0 c02d95a9 c2776e8c c26a7a90 c26a7bc4 
[  292.057398]        c17fd0c0 00000000 c2776e88 c2603000 c2776ea8 c011b83a c2776ea0 00000000 
[  292.057930]        00000000 00000003 00000000 00000000 00000003 c2776eb8 c0141de0 c2776fb8 
[  292.058450] Call Trace:
[  292.058576]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.058696]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.058819]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.058945]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.059065]  =======================
[  292.059134] mysqld        D c03d40c0     0  2438   2393
[  292.059301]        c254deac 00000086 c03d0eb0 c03d40c0 00000000 00000000 c1c9fa90 c1c9fbc4 
[  292.059762]        c18060c0 00000001 c254de88 c2603000 c254dea8 c011b83a c254dea0 00000000 
[  292.060281]        00000000 b3435390 00000000 00000000 b3435390 c254deb8 c0141de0 c254dfb8 
[  292.060801] Call Trace:
[  292.060927]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.061047]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.061169]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.061290]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.061411]  =======================
[  292.061479] mysqld        D c03d40c0     0  2439   2393
[  292.061648]        c254feac 00000086 c03d0eb0 c03d40c0 00000000 00000000 c26a6000 c26a6134 
[  292.062122]        c18060c0 00000001 c254fe88 c2603000 c254fea8 c011b83a c254fea0 00000000 
[  292.062642]        00000000 b2c34380 00000000 00000000 b2c34380 c254feb8 c0141de0 c254ffb8 
[  292.063168] Call Trace:
[  292.063294]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.063414]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.063536]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.063659]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.063779]  =======================
[  292.063847] mysqld        D c03d40c0     0  2440   2393
[  292.064016]        c30a7eac 00000086 c03d0eb0 c03d40c0 c02d95a9 c30a7e8c c1ca2ff0 c1ca3124 
[  292.064476]        c17fd0c0 00000000 c30a7e88 c2603000 c30a7ea8 c011b83a c30a7ea0 00000000 
[  292.064997]        00000000 00000003 00000000 00000000 00000003 c30a7eb8 c0141de0 c30a7fb8 
[  292.065518] Call Trace:
[  292.065643]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.065764]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.065898]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.066020]  [<c0103f06>] work_notifysig+0x13/0x19
[  292.066162]  =======================
[  292.066232] mysqld        S c03d40c0     0  2441   2393
[  292.066401]        c2ff0ec4 00000086 c03d0eb0 c03d40c0 c25d0e88 c04fd0c0 c1ca2aa0 c1ca2bd4 
[  292.066862]        c18060c0 00000001 c02d9534 c2603000 c013bcd3 ffffe51d 00000003 00000000 
[  292.067388]        00000000 00000000 7fffffff 00000000 7fffffff c2ff0f04 c02d82dd c2ff0ef0 
[  292.067909] Call Trace:
[  292.068035]  [<c02d82dd>] schedule_timeout+0x16/0x8b
[  292.068155]  [<c02d837e>] schedule_timeout_interruptible+0x15/0x17
[  292.068279]  [<c012bf82>] sys_rt_sigtimedwait+0x131/0x203
[  292.068401]  [<c0103e02>] sysenter_past_esp+0x5f/0x85
[  292.068521]  =======================
[  292.068590] mysqld        D c03d40c0     0  2444   2393
[  292.068758]        c27a1eac 00000086 c03d0eb0 c03d40c0 c2ff1cc0 c02f2b7c c2c67540 c2c67674 
[  292.069219]        c17fd0c0 00000000 c27a1e88 c2603000 c27a1ea8 c011b83a c27a1ea0 00000000 
[  292.069739]        00000000 0000000b 00000000 00000000 0000000b c27a1eb8 c0141de0 c27a1fb8 
[  292.070273] Call Trace:
[  292.070399]  [<c0141de0>] refrigerator+0xcf/0xdb
[  292.070520]  [<c012b4d2>] get_signal_to_deliver+0x33/0x414
[  292.070644]  [<c01034e8>] do_notify_resume+0x81/0x61e
[  292.070764]  [<c0103f06>] work_notifysig+0x13/0x19
...
[  292.293751]  =======================
[  292.293819] s2ram         R running      0  3804   3803
[  292.294003]  mysqld
[  292.294085] 
[  292.294150] Restarting tasks ... <7>PM: Adding info for No Bus:vcs63
[  292.294669] done.

As suggested in a different post I'll try reverting
freezer-use-wait-queue-instead-of-busy-looping.patch and re-test

-- 
mattia
:wq!
