Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZHJUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZHJUHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZHJUHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:07:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64508 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZHJUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:07:16 -0400
X-SpamScore: -36
X-BigFish: VPS-36(z21eWz62a3L1432R98dN936eM19c2kzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO6FUM-02-GK6-02
X-M-MSG: 
Date: Mon, 10 Aug 2009 22:05:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Johannes Stezenbach <js@sig21.net>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810200529.GC2258@erda.amd.com>
References: <20090807170942.GB9177@sig21.net> <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810194413.GE6838@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090810194413.GE6838@basil.fritz.box>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Aug 2009 20:05:30.0885 (UTC) FILETIME=[E9832B50:01CA19F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.09 21:44:13, Andi Kleen wrote:
> > But in demsg I got this:
> 
> AFAIK that's already fixed. cc Robert to confirm. Not sure if the fix  made it into 2.6.31 though?

The warning I fixed was in rb_advance_reader(). Fix is already
upstream:

 193df82 ring-buffer: Fix advance of reader in rb_buffer_peek()

But this seems to be different, a time stamp issue?

CC'ing Steve.

-Robert

> 
> -Andi
> 
> > 
> > Delta way too big! 18446744022868427516 ts=18446744022868427516 write stamp = 0
> > ------------[ cut here ]------------
> > WARNING: at kernel/trace/ring_buffer.c:1392 rb_reserve_next_event+0x150/0x309()
> > Hardware name: 2373Y4M
> > Modules linked in: ath5k mac80211 ath cfg80211 oprofile bnep sco rfcomm l2cap bluetooth ehci_hcd uhci_hc
> > Pid: 13478, comm: opcontrol Not tainted 2.6.31-rc5 #5
> > Call Trace:
> >  [<c10248dd>] warn_slowpath_common+0x60/0x90
> >  [<c102491a>] warn_slowpath_null+0xd/0x10
> >  [<c1054129>] rb_reserve_next_event+0x150/0x309
> >  [<c1068c06>] ? get_page_from_freelist+0x86/0x35a
> >  [<c10544f7>] ring_buffer_lock_reserve+0xe7/0x135
> >  [<f88622c0>] op_cpu_buffer_write_reserve+0x1a/0x4b [oprofile]
> >  [<f886239d>] op_add_code+0x57/0x98 [oprofile]
> >  [<c1068c06>] ? get_page_from_freelist+0x86/0x35a
> >  [<c1367c08>] ? page_fault+0x0/0x8
> >  [<f8862409>] log_sample+0x2b/0x6c [oprofile]
> >  [<c1064c76>] ? filemap_fault+0x74/0x32b
> >  [<f886249c>] oprofile_add_sample+0x3b/0x6b [oprofile]
> >  [<f88641d8>] ppro_check_ctrs+0x66/0xdb [oprofile]
> >  [<c1074bde>] ? __do_fault+0x303/0x32f
> >  [<f8863907>] profile_exceptions_notify+0x1f/0x26 [oprofile]
> >  [<c103953b>] notifier_call_chain+0x2b/0x55
> >  [<c10398e3>] __atomic_notifier_call_chain+0x1a/0x3a
> >  [<c103990f>] atomic_notifier_call_chain+0xc/0xe
> >  [<c103993e>] notify_die+0x2d/0x2f
> >  [<c1003c54>] do_nmi+0x63/0x222
> >  [<c1367d1d>] nmi_stack_correct+0x28/0x2d
> >  [<c1367c08>] ? page_fault+0x0/0x8
> > ---[ end trace d174f39c63495e01 ]---
> > 
> > 
> > Thanks
> > Johannes
> > 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

