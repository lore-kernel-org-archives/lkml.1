Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbYBNWEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbYBNWEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYBNWEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:04:14 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:20659 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYBNWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:04:12 -0500
To: "Tony Luck" <tony.luck@intel.com>
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
X-Message-Flag: Warning: May contain useful information
References: <20080213125725.GC6344@elte.hu>
	<20080213.050340.64342037.davem@davemloft.net>
	<12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	<20080213.170452.68851396.davem@davemloft.net>
	<12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
	<adaprv0rygh.fsf@cisco.com>
	<12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 14 Feb 2008 14:04:05 -0800
In-Reply-To: <12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com> (Tony Luck's message of "Thu, 14 Feb 2008 13:27:58 -0800")
Message-ID: <ada7ih7qjoq.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 22:04:05.0976 (UTC) FILETIME=[8421A580:01C86F55]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  The strange thing is that Ingo's patch to make cpu_clock() a NOP until
 > >  after sched_init() didn't fix things for me...

 > Very strange.  I threw in an output line counter into the printk code() ... if I
 > disable the timestamps for the first 30 lines, then everything is good (so the
 > basic timestamping code does still work on ia64). But I would have thought
 > that Ingo's delay until sched_init() ought to be long enough too. Clearly I
 > need to figure out exactly what needs to be initialized to prevent the
 > hang/crash.

I guess sched_init() is too early... it does seem really strange to
me, but I just double checked with Ingo's patch and it does indeed
hang.  The slow way to make progress is just to go through
start_kernel() line-by-line and enable cpu_clock() at each stage, and
see where it stops hanging.  I'll give that a shot as a background
process (my ia64 box takes quite a while to boot, so each test takes a
long time but requires very little of my attention).
