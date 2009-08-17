Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbZHQFIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbZHQFIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZHQFIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:08:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:65064 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZHQFIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:08:45 -0400
Message-ID: <4A88E5CC.6050706@vflare.org>
Date: Mon, 17 Aug 2009 10:38:28 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
References: <200908122007.43522.ngupta@vflare.org> <20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090817115529.59395cea.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 08:25 AM, KAMEZAWA Hiroyuki wrote:
> On Wed, 12 Aug 2009 20:07:43 +0530
> Nitin Gupta<ngupta@vflare.org>  wrote:
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
>>
>
> Hmm, do you really need notify at *every* swap free ?
> No batching is necessary ?
>

We need notify for every swap free and no batching is desired, at least for 
compcache case.

Thanks,
Nitin
