Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0BJESW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 23:18:22 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:39442 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJESU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 23:18:20 -0500
Message-ID: <4B723398.70806@billgatliff.com>
Date: Tue, 09 Feb 2010 22:18:32 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/7] API to consolidate PWM devices behind a common
 user and kernel interface
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com> <4B723239.4090802@billgatliff.com>
In-Reply-To: <4B723239.4090802@billgatliff.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff wrote:
>>> +
>>> +	p->requester = requester;
>>> +	if (!strcmp(requester, REQUEST_SYSFS))
>>> +		p->pid = current->pid;
>>>     
>>>       
>> This is new.. What's the reason for saving the pid?
>>   
>>     
>
> I've gotten complaints from those who say, "Ok, so it reported 'sysfs'
> back to me, but how can I be sure that it's because *I* own it now, and
> not another user process?"  Seemed easy enough to add the PID so they
> can check.  Of course, you could argue that I could report just the PID,
> and skip the "sysfs" string altogether.  I'd be inclined to agree with you.
>
> Of course, if you are like me and do the request with cat(1), then the
> PID is pretty meaningless.  :)
>   

For the record, this request activity is mostly advisory.  I can't
actually implement something where only the requester is subsequently
allowed to manipulate the state of the channel.  You really wouldn't
want to even if it was possible, because then you'd probably lose the
ability to control the output using cat(1) and echo(1).

I'm just trying to provide a tool that allows users to Play Nice if they
choose to.  In fact, it's currently possible to manipulate the state of
the channel from userspace without requesting ownership first.  Not sure
I'm happy with that, but since I can't enforce any sort of access
restrictions it seems pointless to even go so far as to require ownership...


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

