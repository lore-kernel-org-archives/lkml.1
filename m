Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZHMClm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZHMClm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZHMCll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:41:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:58731 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZHMCll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:41:41 -0400
Message-ID: <4A837D5A.3070407@vflare.org>
Date: Thu, 13 Aug 2009 08:11:30 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 04:18 AM, Hugh Dickins wrote:
> On Wed, 12 Aug 2009, Nitin Gupta wrote:
>
>> Currently, we have "swap discard" mechanism which sends a discard bio request
>> when we find a free cluster during scan_swap_map(). This callback can come a
>> long time after swap slots are actually freed.
>>
>> This delay in callback is a great problem when (compressed) RAM [1] is used
>> as a swap device. So, this change adds a callback which is called as
>> soon as a swap slot becomes free. For above mentioned case of swapping
>> over compressed RAM device, this is very useful since we can immediately
>> free memory allocated for this swap page.
>>
>> This callback does not replace swap discard support. It is called with
>> swap_lock held, so it is meant to trigger action that finishes quickly.
>> However, swap discard is an I/O request and can be used for taking longer
>> actions.
>>
>> Links:
>> [1] http://code.google.com/p/compcache/
>
> Please keep this with compcache for the moment (it has no other users).
>

Oh, I missed this one.

This small patch can be considered as first step for merging compcache 
to mainline :)   Actually, it requires callbacks for swapon, swapoff too 
but that, I think, should be done in a separate patches.

BTW, last time compcache was not accepted due to lack of performance 
numbers. Now the project has lot more data for various cases:
http://code.google.com/p/compcache/wiki/Performance
Still need to collect data for worst-case behaviors and such...


Thanks,
Nitin
