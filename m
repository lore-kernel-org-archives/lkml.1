Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZBSNXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZBSNXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZBSNXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:23:45 -0500
Received: from 137-67-76-76.skybeam.com ([76.76.67.137]:1354 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZBSNXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:23:44 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 08:23:44 EST
Message-ID: <499D5B99.3000404@mlbassoc.com>
Date: Thu, 19 Feb 2009 06:16:09 -0700
From: Gary Thomas <gary@mlbassoc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
References: <alpine.LRH.2.00.0902191334550.15109@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0902191334550.15109@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> When running 2.6.29-rc5+ on PS3 (ppc64), I got the following BUG once during
> bootup:
> 
> | Freeing unused kernel memory: 3436k freed
> | BUG: MAX_STACK_TRACE_ENTRIES too low!
> | turning off the locking correctness validator.
> | Call Trace:
> | [c000000006e1b640] [c00000000000f850] .show_stack+0x6c/0x16c (unreliable)
> | [c000000006e1b6f0] [c00000000007cf6c] .save_trace+0xe0/0x108
> | [c000000006e1b780] [c00000000007d058] .add_lock_to_list+0xc4/0x124
> | [c000000006e1b830] [c0000000000816d0] .__lock_acquire+0x13c4/0x17c8
> | [c000000006e1b930] [c000000000081b78] .lock_acquire+0xa4/0xec
> | [c000000006e1b9f0] [c0000000003be034] ._spin_lock+0x34/0x58
> | [c000000006e1ba80] [c0000000000d3e40] .kmem_cache_free+0x84/0x1a8
> | [c000000006e1bb30] [c0000000001f9abc] .idr_remove+0x214/0x248
> | [c000000006e1bbf0] [c00000000002867c] .destroy_context+0x34/0x64
> | [c000000006e1bc80] [c00000000005008c] .__mmdrop+0x4c/0x7c
> | [c000000006e1bd10] [c00000000004de90] .finish_task_switch+0xec/0x14c
> | [c000000006e1bdb0] [c00000000004e6fc] .schedule_tail+0x2c/0xa0
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> | [c000000006e1be30] [c000000000007738] .ret_from_fork+0x4/0xcc
> 
> (There are 65 call trace lines)
> 
> After that the system continued.

It looks like the stack trace code got stuck in a loop (the last
53 entries are identical) - increasing the limit won't change this,
it would just keep more entries.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
