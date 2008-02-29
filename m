Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbYB2Q33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbYB2Q33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932568AbYB2Q3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:29:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57628 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbYB2Q3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:29:19 -0500
Message-ID: <47C832AC.4040906@us.ibm.com>
Date: Fri, 29 Feb 2008 08:28:28 -0800
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, systemtap@sourceware.org,
       prasadav@us.ibm.com, hch@infradead.org
Subject: Re: [patch 2/3]  Trace code and documentation
References: <1204065528.26964.17.camel@lc4eb748232119.ibm.com> <20080228020441.a08e4772.akpm@linux-foundation.org>
In-Reply-To: <20080228020441.a08e4772.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 26 Feb 2008 14:38:48 -0800 "David J. Wilder" <dwilder@us.ibm.com> wrote:
> 
>> +	if (strncmp(buf, "start", strlen("start")) == 0) {
>> +		ret = trace_start(trace);
>> +		if (ret)
>> +			return ret;
>> +	} else if (strncmp(buf, "stop", strlen("stop")) == 0)
>> +		trace_stop(trace);
> 
> Does gcc manage to avoid the pointless strlen() calls here?
> 
> It's a bit untidy that you can write "startfoo" in there and the kernel
> will happily accept it.

I agree.  I will change it to something like this in my next update.


buf[count-1] = '\0';

if (strcmp(buf, "start") == 0) {
	ret = trace_start(trace);
	if (ret)
		return ret;
} else if (strcmp(buf, "stop") == 0)
	trace_stop(trace);
else
	return -EINVAL;



