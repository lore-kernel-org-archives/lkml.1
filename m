Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbZHCPPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbZHCPPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbZHCPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:15:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbZHCPPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:15:33 -0400
Date: Mon, 3 Aug 2009 18:14:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: davidel@xmailserver.org, gleb@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
Message-ID: <20090803151426.GA3630@redhat.com>
References: <cover.1248803500.git.mst@redhat.com> <20090728175538.GC21549@redhat.com> <4A76FDB2.7080706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76FDB2.7080706@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:09:38PM +0300, Avi Kivity wrote:
> On 07/28/2009 08:55 PM, Michael S. Tsirkin wrote:
>> This implements a new EFD_STATE flag for eventfd.
>> When set, this flag changes eventfd behaviour in the following way:
>> - write simply stores the value written, and is always non-blocking
>> - read unblocks when the value written changes, and
>>    returns the value written
>>
>> Motivation: we'd like to use eventfd in qemu to pass interrupts from
>> (emulated or assigned) devices to guest. For level interrupts, the
>> counter supported currently by eventfd is not a good match: we really
>> need to set interrupt to a level, typically 0 or 1, and give the guest
>> ability to see the last value written.
>>
>>
>> @@ -31,37 +31,59 @@ struct eventfd_ctx {
>>   	 * issue a wakeup.
>>   	 */
>>   	__u64 count;
>> +	/*
>> +	 * When EF_STATE flag is set, eventfd behaves differently:
>> +	 * value written gets stored in "count", read will copy
>> +	 * "count" to "state".
>> +	 */
>> +	__u64 state;
>>   	unsigned int flags;
>>   };
>>    
>
> Why not write the new value into ->count directly?

That's what it says. state is ther to detect that value was changed
after last read. Makes sense?

> -- 
> error compiling committee.c: too many arguments to function
