Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZJLJag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZJLJag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZJLJaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:30:35 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59936 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZJLJae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:30:34 -0400
Message-ID: <4AD2F70C.4010506@linux.vnet.ibm.com>
Date: Mon, 12 Oct 2009 11:29:48 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com> <1255090830.8802.60.camel@laptop> <20091009122952.GI9228@kernel.dk> <20091009154950.43f01784@mschwide.boeblingen.de.ibm.com> <20091011011006.GA20205@localhost> <4AD2C43D.1080804@linux.vnet.ibm.com> <20091012062317.GA10719@localhost>
In-Reply-To: <20091012062317.GA10719@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> [SNIP]
>>> May I ask for more details about your performance regression and why
>>> it is related to readahead size? (we didn't change VM_MAX_READAHEAD..)
>>>   
>>>       
>> Sure, the performance regression appeared when comparing Novell SLES10 
>> vs. SLES11.
>> While you are right Wu that the upstream default never changed so far, 
>> SLES10 had a
>> patch applied that set 512.
>>     
>
> I see. I'm curious why SLES11 removed that patch. Did it experienced
> some regressions with the larger readahead size?
>
>   

Only the obvious expected one with very low free/cacheable
memory and a lot of parallel processes that do sequential I/O.
The RA size scales up for all of them but 64xMaxRA then
doesn't fit.

For example iozone with 64 threads (each on one disk for its own),
sequential access pattern read with I guess 10 M free for cache
suffered by ~15% due to trashing.

But that is a acceptable regression because it is no relevant
customer scenario, while the benefits apply to customer scenarios.

[...]
>> And as Andrew mentioned the diversity of devices cause any default to be 
>> wrong for one
>> or another installation. To solve that the udev approach can also differ 
>> between different
>> device types (might be easier on s390 than on other architectures 
>> because I need to take
>> care of two disk types atm - and both shold get 512).
>>     
>
> I guess it's not a general solution for all. There are so many
> devices in the world, and we have not yet considered the
> memory/workload combinations.
>   
I completely agree, let me fix "my" issue per udev for now.
And if some day the readahead mechanism evolves and
doesn't need any max RA at all we can all be happy.

[...]

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

