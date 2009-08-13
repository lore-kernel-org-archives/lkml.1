Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZHMOoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZHMOoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZHMOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:44:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:25354 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZHMOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:44:43 -0400
Message-ID: <4A8426CE.5090605@vflare.org>
Date: Thu, 13 Aug 2009 20:14:30 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
References: <200908122007.43522.ngupta@vflare.org>	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>	 <4A837AAF.4050103@vflare.org> <1250146380.10001.47.camel@twins>
In-Reply-To: <1250146380.10001.47.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending in plain text)

On 08/13/2009 12:23 PM, Peter Zijlstra wrote:
> On Thu, 2009-08-13 at 08:00 +0530, Nitin Gupta wrote:
>>> I don't share Peter's view that it should be using a more general
>>> notifier interface (but I certainly agree with his EXPORT_SYMBOL_GPL).
>> Considering that the callback is made under swap_lock, we should not
>> have an array of callbacks to do. But what if this callback finds other
>> users too? I think we should leave it in its current state till it finds
>> more users and probably add BUG() to make sure callback is not already set.
>>
>> I will make it EXPORT_SYMBOL_GPL.
>
> If its such a tightly coupled system, then why is compcache a module?
>

Keeping everything as separate kernel modules has been the goal of this 
project. However, this callback is the only thing which I could not do 
without this small patching.

Nitin
