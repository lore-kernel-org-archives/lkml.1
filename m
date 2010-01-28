Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591Ab0A1ERe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0A1ERe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0A1ERd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:17:33 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:14818 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab0A1ERc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:17:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscAAAKfYEtLd/sX/2dsb2JhbAAIgzHEfo94gSqCN1gE
X-IronPort-AV: E=Sophos;i="4.49,358,1262581200"; 
   d="scan'208";a="54724280"
Message-ID: <4B610FDA.50104@teksavvy.com>
Date: Wed, 27 Jan 2010 23:17:30 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <20100127120820.GB25750@csn.ul.ie> <4B60C0A7.7090501@teksavvy.com>
In-Reply-To: <4B60C0A7.7090501@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mel Gorman wrote:
>> On Tue, Jan 26, 2010 at 09:13:27PM -0500, Mark Lord wrote:
>>> I recently upgraded our 24/7 server from 2.6.31.5 to 2.6.32.5.
>>>
>>> Now, suddenly the logs are full of "page allocation failure. order:1",
>>> and the odd "page allocation failure. order:4" failures.
>>>
>>> Wow.  WTF happened in 2.6.32 ???
>>>
>>
>> There was one bug related to MIGRATE_RESERVE that might be affecting
>> you. It reported as impacting swap-orientated workloads but it could
>> easily affect drivers that depend on high-order atomic allocations.
>> Unfortunately, the fix is not signed-off yet but I expect it to make its
>> way towards mainline when it is.
>>
>> Here is the patch with a slightly-altered changelog. Can you test if it
>> makes a difference please?
> ..
> 
> We don't like to reboot our 24/7 server very often,
> and certainly not for debugging buggy kernels.
> 
> It's rock solid again with 2.6.31.12 on it now.
> 
> The defining characteristic of that machine, is that it has only 512MB
> of physical RAM.  So perhaps I'll try booting a different machine here
> with mem=512M and see how that behaves.  If the problem shows up on that,
> then I'll try the patch.
..

Sod it.  2.6.32 is simply too broken for us here on 32-bit non-SMP.

Attempting to boot a 32-bit kernel with "nosmp mem=512M" on my notebook
locks up at boot time with several repeated messages like this:

   request_module: runaway loop modprobe binfmt_464c

Useless kernel on 32-bit.  I hope 2.6.33 ends up less buggy.

Cheers
