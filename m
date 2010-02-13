Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0BMI3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:29:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab0BMI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:29:38 -0500
Message-ID: <4B7662EF.9070302@redhat.com>
Date: Sat, 13 Feb 2010 10:29:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64, rwsem: Avoid store forwarding hazzard in __downgrade_write
References: <1266045183-9563-1-git-send-email-avi@redhat.com> <4B765FFA.1020505@zytor.com>
In-Reply-To: <4B765FFA.1020505@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 10:16 AM, H. Peter Anvin wrote:
> On 02/12/2010 11:13 PM, Avi Kivity wrote:
>    
>> +#ifndef CONFIG_X86_64
>> +		       "i" (-RWSEM_WAITING_BIAS)
>> +#else
>> +		       "r" (-RWSEM_WAITING_BIAS)
>>   #endif
>> +		     : "memory", "cc");
>>      
> Using an "er" constraint here should work on both architectures.
>
>    

Right.  v2 to follow.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

