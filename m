Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYB1NNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYB1NNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYB1NNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:13:37 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:30704 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYB1NNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:13:36 -0500
Message-ID: <47C6B373.8020605@fr.ibm.com>
Date: Thu, 28 Feb 2008 14:13:23 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by signal_group_exit()
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>	<47B7B3B9.2090706@linux.vnet.ibm.com>	<20080220143417.6e419c5e@cuia.boston.redhat.com>	<20080220200440.GA105@tv-sign.ru> <20080220175309.6ce3cb31@cuia.boston.redhat.com>
In-Reply-To: <20080220175309.6ce3cb31@cuia.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

Rik van Riel wrote:
> On Wed, 20 Feb 2008 23:04:40 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
>> Yes, please look at http://marc.info/?t=120309840500006
>>
>> Btw. The bug in tty_io.c _can_ explain this trace, but it would be nice
>> to ensure we don't have other problems. Could you try this
>>
>> 	http://marc.info/?l=linux-kernel&m=120352655031911
>>
>> patch?
> 
> Fun.  With that debugging patch applied, the oops on boot no longer
> happens...
> 
> No, I have no idea why...

It also fixed a oops at boot time for me. Here's a warning I got with oleg patch.

Thanks,

C.

WARNING: at /home/legoater/linux/2.6.25-rc2-mm1/kernel/pid.c:213 put_pid+0x4b/0x82()
Modules linked in: tg3 sg joydev ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 1, comm: init Not tainted 2.6.25-rc2-mm1 #6

Call Trace:
 [<ffffffff8022f0a1>] warn_on_slowpath+0x58/0x85
 [<ffffffff8024b87d>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8024b84c>] ? trace_hardirqs_on_caller+0xf2/0x116
 [<ffffffff8024b87d>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8024b84c>] ? trace_hardirqs_on_caller+0xf2/0x116
 [<ffffffff8023fb0f>] put_pid+0x4b/0x82
 [<ffffffff802ccd6e>] ? proc_delete_inode+0x0/0x4f
 [<ffffffff802ccd90>] proc_delete_inode+0x22/0x4f
 [<ffffffff802ccd6e>] ? proc_delete_inode+0x0/0x4f
 [<ffffffff802a0826>] generic_delete_inode+0xb8/0x138
 [<ffffffff8029fd5d>] iput+0x7c/0x80
 [<ffffffff8029d835>] dentry_iput+0xa3/0xbb
 [<ffffffff8029d8ea>] d_kill+0x21/0x42
 [<ffffffff8029ebee>] dput+0x114/0x125
 [<ffffffff802cefe0>] proc_flush_task+0x125/0x28f
 [<ffffffff8024b87d>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff802312a5>] release_task+0x24/0x331
 [<ffffffff80231ca1>] do_wait+0x6ef/0xa99
 [<ffffffff80227b43>] ? default_wake_function+0x0/0xf
 [<ffffffff802320dc>] sys_wait4+0x91/0xab
 [<ffffffff8020b21b>] system_call_after_swapgs+0x7b/0x80

