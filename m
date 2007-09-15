Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbXIOEro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbXIOEro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 00:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXIOErh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 00:47:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38916 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXIOErg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 00:47:36 -0400
Message-ID: <46EB63E4.8060107@us.ibm.com>
Date: Fri, 14 Sep 2007 21:47:32 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCH 1/2] Trace code and documentation
References: <46E9CB14.7060000@us.ibm.com> <20070914180840.579627ab.akpm@linux-foundation.org>
In-Reply-To: <20070914180840.579627ab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> +/*
>> + * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
>>     
>
> So can we migrate blktrace to using this?
>   
Yes, a blktrace patch is comming.

>> +	int ret;
>> +
>> +	if (trace->flags & TRACE_DISABLE_STATE)
>> +		return -EINVAL;
>> +	
>> +	if (count > sizeof(buf) - 1)
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(buf, buffer, count))
>> +		return -EFAULT;
>> +
>> +	buf[count] = '\0';
>> +	
>> +	if (strncmp(buf, "start", strlen("start")) == 0 ) {
>> +		ret = trace_start(trace);
>> +		if (ret)
>> +			return ret;
>> +	} else if (strncmp(buffer, "stop", strlen("stop")) == 0)
>> +		trace_stop(trace);
>> +	else
>> +		return -EINVAL;
>>     
>
> What's the above code doing?  Trying to cope with trailing chars after
> "start" or "stop"?  Is that actually needed?   It's the \n, I assume?
>   

Yes, the typical usage is "echo start > state" and echo adds a \n.


Thanks for the comments, I will make the changes and resubmit.

