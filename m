Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXCRO4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXCRO4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXCRO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:56:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:42350 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXCRO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:56:36 -0400
Message-ID: <45FD53DB.5000207@tmr.com>
Date: Sun, 18 Mar 2007 09:59:39 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
       linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, nikita@clusterfs.com,
       leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org>
In-Reply-To: <20070315110745.af867b10.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Wed, 14 Mar 2007 21:42:46 +0900 Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:
>>
>> ...
>>
>>
>> -Solution:
>>
>> I consider that all of the dirty pages for the disk have been written
>> back and that the disk is clean if a process cannot write 'write_chunk'
>> pages in balance_dirty_pages().
>>
>> To avoid using up the free memory with dirty pages by passing blocking,
>> this patchset adds a new threshold named vm.dirty_limit_ratio to sysctl.
>>
>> It modifies balance_dirty_pages() not to block when the amount of
>> Dirty+Writeback is less than vm.dirty_limit_ratio percent of the memory.
>> In the other cases, writers are throttled as current Linux does.
>>
>>
>> In this patchset, vm.dirty_limit_ratio, instead of vm.dirty_ratio, is
>> used as the clamping level of Dirty+Writeback. And, vm.dirty_ratio is
>> used as the level at which a writers will itself start writeback of the
>> dirty pages.
> 
> Might be a reasonable solution - let's see what Peter comes up with too.
> 
> Comments on the patch:
> 
> - Please don't VM_DIRTY_LIMIT_RATIO: just use CTL_UNNUMBERED and leave
>   sysctl.h alone.
> 
> - The 40% default is already too high.  Let's set this new upper limit to
>   40% and decrease he non-blocking ratio.
> 
> - Please update the procfs documentation in ./Docmentation/
> 
> - I wonder if dirty_limit_ratio is the best name we could choose. 
>   vm_dirty_blocking_ratio, perhaps?  Dunno.
> 
I don't like it, but I dislike it less than "dirty_limit_ratio" I guess. 
It would probably break things to change it now, including my 
sysctl.conf on a number of systems :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
