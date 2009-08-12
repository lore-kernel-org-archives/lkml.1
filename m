Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZHLN34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZHLN34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZHLN3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:29:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:23460 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZHLN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:29:55 -0400
Message-ID: <4A82C3C6.5010302@vflare.org>
Date: Wed, 12 Aug 2009 18:59:42 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] swap: send callback when swap slot is freed
References: <200908121817.48501.ngupta@vflare.org> <20090812125617.GA30476@elte.hu>
In-Reply-To: <20090812125617.GA30476@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 06:26 PM, Ingo Molnar wrote:
> * Nitin Gupta<ngupta@vflare.org>  wrote:
>
>> (Re-sending since I didn't get any reply last time)
>>
>> Currently, we have "swap discard" mechanism which sends a discard
>> bio request when we find a free cluster during scan_swap_map().
>> This callback can come a long time after swap slots are actually
>> freed.
>>
>> This delay in callback is a great problem when (compressed) RAM
>> [1] is used as a swap device. So, this change adds a callback
>> which is called as soon as a swap slot becomes free. For above
>> mentioned case of swapping over compressed RAM device, this is
>> very useful since we can immediately free memory allocated for
>> this swap page.
>>
>> This callback does not replace swap discard support. It is called
>> with swap_lock held, so it is meant to trigger action that
>> finishes quickly. However, swap discard is an I/O request and can
>> be used for taking longer actions.

<snip>

>
> Shouldnt this be all be unconditional? Sounds like a reasonable VM
> callback. The patch would become a lot smaller as well.
>


I also think this can be made unconditional as it makes the patch
much cleaner. I made it conditional just to be on path of least
resistance :)

Thanks for looking into this. I will resend the patch removing
all the #ifdef'ery.

Nitin
