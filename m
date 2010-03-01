Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0CATTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:19:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0CATTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:19:20 -0500
Message-ID: <4B8C1320.6060602@redhat.com>
Date: Mon, 01 Mar 2010 09:18:56 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com> <20100301190341.GD12867@redhat.com>
In-Reply-To: <20100301190341.GD12867@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 09:03 AM, Gleb Natapov wrote:
> On Mon, Mar 01, 2010 at 08:39:49AM -1000, Zachary Amsden wrote:
>    
>
>> Anything that can generate exceptions is going to need logic to
>> handle error cases anyway... the depth can not be that bad.
>> Especially if you structure it so as to optimize for tail calling.
>>
>>      
> Tail call is not what usually happens. Usually emulation goes like this:
>   if (check some conditions) {
> 	queue exception A
>          return exception queued
>   }
>   if (check other conditions) {
> 	queue exception B
>          return exception queued
>   }
>   do some emulation
>   try to read guest memory
>   if (read failed) {
>      queue exception C
>      return exception queued
>   }
>   if (read needs exit to userspace for device emulation)
>      return please go out and retrieve me the data
>
>   continue emulation
>   try to write guest memory
>   if (write failed) {
>      queue exception C
>      return exception queued
>   }
>   if (write needs exit to userspace for device emulation)
>      return please go out and process the data
>
>   emulate some more.
>
>   return emulation done
>    

It's going to be ugly to emulate segmentation, NX and write protect 
support without hardware to do this checking for you, but it's just what 
you have to do in this slow path - tedious, fully specified emulation.

Just because it's tedious doesn't mean we need to use setjmp / longjmp.  
Throw / catch might be effective, but it's still pretty bizarre to do 
tricks like that in C.

Zach
