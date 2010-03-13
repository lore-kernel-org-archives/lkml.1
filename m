Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab0CMAj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:39:59 -0500
Received: from borg.medozas.de ([188.40.89.202]:52145 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935740Ab0CMAev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:34:51 -0500
Date: Sat, 13 Mar 2010 01:34:49 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: page_to_nid not linked in on PAE
In-Reply-To: <4B9AC149.1010507@linux.intel.com>
Message-ID: <alpine.LSU.2.01.1003130132120.24334@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003091210230.10157@obet.zrqbmnf.qr>  <alpine.LSU.2.01.1003101128340.9318@obet.zrqbmnf.qr> <1268423424.2793.21.camel@sbs-t61.sc.intel.com> <4B9AC149.1010507@linux.intel.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-03-12 23:33, Andi Kleen wrote:
>
>> Jan, Even with out using the PG_head, PG_tail, PG_uncached and
>> PG_hwpoison, by allowing the NODES_SHIFT to have a maximum value of 9 on
>> 32bit kernel, can still result in the page flags to runout and result in
>> this problem. Best solution for now is to limit the NODES_SHIFT to 5. I
>> don't know of any platforms that have>  32nodes and where we care about
>> 32bit linux kernel. So it should be ok as a fix. If someone in future
>> cares about>  32 nodes for 32bit kernel, then we can think of a better
>> solution. Do you agree? I copied Andi/Nick for their eyes aswell on
>> this.
>
> Seems like the right approach to me. Although it might be better to
> use 1 3 or 1..4 or so, just in case someone else adds more page bits
> later (I'm sure it'll happen again). Even 8 nodes should be plenty for
> 32bit.

Perfectly fine with me. Though I wonder: with SPARSEMEM selected,
I can easily choose the maximum possible value for NODES_SHIFT,
(currently 9, limited imposed by arch/x86/Kconfig).
