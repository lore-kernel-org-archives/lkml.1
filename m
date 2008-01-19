Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYASTrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYASTrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYASTrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:47:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:28789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYASTrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:47:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YBTWiqGvOZBDqbpOVPbo9tFxPS1BbDRPw3/6U9ACSoQClZkg6WX7jXXCjdH8kUQjWEMuhfvXRb75KKVPkb3r59Js85IJQJSv9y3W0RT+dKKSkRXJzGZcpKiM9IxS/z5SCni5NjCaazOZCMzZzYD9zHucf1mv4YHWngmvpXkRMl0=
Message-ID: <479253D3.4020608@gmail.com>
Date: Sat, 19 Jan 2008 21:47:31 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] LatencyTop: make reason (blk_execute_rq+0x7a/0xd) known
References: <47922B2A.7070709@gmail.com> <479241B0.8010500@linux.intel.com>
In-Reply-To: <479241B0.8010500@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Török Edwin wrote:
>>
>> Cause                                               Maximum         
>> Average
>> SCSI device ioctl                                  34.2 msec       
>> 14.4 msec
>
> great! I'll put this into my patchkit!

Thanks.

>> I also noticed some unsigned overflows, my top latency was sometimes a
>> very large number (18................................), which
>> was probably -1, or some other negative number.  I haven't found a way
>> to reproduce it yet (it happens very rarely).
>
>
> I've not seen this; I'll take another peak at the code.

I just captured this:

Cause                                               Maximum          Average
Waiting for userspace lock                        18446744073638300.0
msec        9223372036783524.0 msec
Waiting for processes to die (waitpid)            18446744073638296.0
msec        9223372036783520.0 msec
Waiting for event (poll)                          18446744073565216.0
msec        764505121372.0 msec
SCSI device ioctl                                  35.2 msec        
13.7 msec
Application requested delay                        19.5 msec         
0.0 msec
page fault                                         18.6 msec         
4.0 msec
Reading from file                                  16.6 msec         
1.5 msec
Waiting for buffer IO                              15.2 msec         
3.0 msec
mutex lock                                         15.0 msec        
15.0 msec

I was also looking at /proc/latency_stats using watch, and I've seen
that there were negative number.
Unfortunately I couldn't copy+paste it, because it was gone too fast.

I was running a program with 4 threads doing usleep(0) in an inf-loop.
However I can't reproduce the overflow now with the same program.

Best regards,
--Edwin
