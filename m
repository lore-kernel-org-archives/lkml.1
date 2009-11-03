Return-Path: <linux-kernel-owner+w=401wt.eu-S1751013AbZKCFPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbZKCFPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZKCFPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:15:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZKCFPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:15:08 -0500
Message-ID: <4AEFBC5E.7020300@redhat.com>
Date: Tue, 03 Nov 2009 07:15:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] Add shared memory hypercall to PV Linux guest.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-2-git-send-email-gleb@redhat.com> <4AEECE2E.2050609@redhat.com> <20091102161809.GG27911@redhat.com>
In-Reply-To: <20091102161809.GG27911@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 06:18 PM, Gleb Natapov wrote:
>>> +#define KVM_PV_SHM_VERSION 1
>>>        
>> versions = bad, feature bits = good
>>
>>      
> I have both! Do you want me to drop version?
>    

Yes.  Once a kernel is released you can't realistically change the version.

>> Some documentation for this?
>>
>> Also, the name should reflect the pv pagefault use.  For other uses
>> we can register other areas.
>>
>>      
> I wanted it to be generic, but I am fine with making it apf specific.
> It will allow to make it smaller too.
>    

Maybe we can squeeze it into the page-fault error code?

>> would solve this.  I prefer using put_user() though than a permanent
>> get_user_pages().
>>
>>      
> I want to prevent it from been swapped out.
>    

Since you don't prevent the page fault handler or code from being 
swapped out, you don't get anything out of it.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

