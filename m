Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZGXKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZGXKVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZGXKVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:21:48 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57522 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbZGXKVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:21:47 -0400
Message-ID: <4A698B3E.4020208@vmware.com>
Date: Fri, 24 Jul 2009 12:21:50 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever possible
 when changing mapping
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> <87ocra1jn6.fsf@basil.nowhere.org>
In-Reply-To: <87ocra1jn6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Thomas Hellstrom <thellstrom@vmware.com> writes:
>
>   
>> The current code uses wbinvd() when the area to flush is > 4MB. Although this
>> may be faster than using clflush() the effect of wbinvd() on irq latencies
>> may be catastrophical on systems with large caches. Therefore use clflush()
>>     
>
> may be? You seem to miss some hard data here.
>
>   
Admittedly.
However, the concept of flushing and invalidating the caches completely 
on systems with many
processors and huge caches when we intend to only flush only small piece 
of the cache also sounds like a big overkill.

Furthermore, since the wbinvd() has been introduced as an optimization 
of the general clflush() case, did somebody ever check the effects on 
systems with many processors and huge caches?

/Thomas

> -Andi
>
>   

