Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZIVJtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZIVJtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZIVJtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbZIVJtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:49:03 -0400
Message-ID: <4AB89D81.5080808@redhat.com>
Date: Tue, 22 Sep 2009 12:48:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com>	<1253342422-13811-1-git-send-email-avi@redhat.com>	<4AB8980D.5070803@redhat.com> <20090922113708.65f655f6@infradead.org>
In-Reply-To: <20090922113708.65f655f6@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 12:37 PM, Arjan van de Ven wrote:
> On Tue, 22 Sep 2009 12:25:33 +0300
> Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 09/19/2009 09:40 AM, Avi Kivity wrote:
>>      
>>> Add a general per-cpu notifier that is called whenever the kernel is
>>> about to return to userspace.  The notifier uses a thread_info flag
>>> and existing checks, so there is no impact on user return or context
>>> switch fast paths.
>>>
>>>        
>> Ingo/Peter?
>>      
> isn't this like really expensive when used ?
>    

No, why?  It triggers a call to do_notify_resume() and a walks a list of 
length 1.

-- 
error compiling committee.c: too many arguments to function

