Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZJAQPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZJAQPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZJAQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:15:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49902 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZJAQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:15:46 -0400
Message-ID: <4AC4D595.2070202@garzik.org>
Date: Thu, 01 Oct 2009 12:15:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Tejun Heo <tj@kernel.org>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more
 flag bit available
References: <1254384558-1018-11-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <10133.1254402320@redhat.com>
In-Reply-To: <10133.1254402320@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 09:05 AM, David Howells wrote:
> Tejun Heo<tj@kernel.org>  wrote:
>
>> +enum {
>> +	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
>> +
>> +	/*
>> +	 * Reserve 3bits off of cwq pointer.  This is enough and
>> +	 * provides acceptable alignment on both 32 and 64bit
>> +	 * machines.
>> +	 */
>> +	WORK_STRUCT_FLAG_BITS	= 3,
>> +
>> +	WORK_STRUCT_FLAG_MASK	= (1UL<<  WORK_STRUCT_FLAG_BITS) - 1,
>> +	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
>> +};
>
> There's some great enum abuse going on here:-)

The quoted code is a standard kernel technique for creating typed 
constants that are visible to the C compiler (rather than CPP) and debugger.

It is found in a great many Linux kernel drivers at this point, and is 
definitely not abuse, IMO.

	Jeff


