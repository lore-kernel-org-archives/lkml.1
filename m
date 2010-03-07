Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab0CGJFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:05:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0CGJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:05:25 -0500
Message-ID: <4B936C1F.4060504@redhat.com>
Date: Sun, 07 Mar 2010 11:04:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zamsden@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com> <20100301190341.GD12867@redhat.com> <4B8C1320.6060602@redhat.com> <4B8C4032.7080703@zytor.com> <4B8C463B.7070900@zytor.com> <20100302084907.GV16909@redhat.com>
In-Reply-To: <20100302084907.GV16909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 10:49 AM, Gleb Natapov wrote:
> On Mon, Mar 01, 2010 at 02:56:59PM -0800, H. Peter Anvin wrote:
>    
>> On 03/01/2010 02:31 PM, H. Peter Anvin wrote:
>>      
>>> On 03/01/2010 11:18 AM, Zachary Amsden wrote:
>>>        
>>>> It's going to be ugly to emulate segmentation, NX and write protect
>>>> support without hardware to do this checking for you, but it's just what
>>>> you have to do in this slow path - tedious, fully specified emulation.
>>>>
>>>> Just because it's tedious doesn't mean we need to use setjmp / longjmp.
>>>> Throw / catch might be effective, but it's still pretty bizarre to do
>>>> tricks like that in C.
>>>>
>>>>          
>>> Well, setjmp/longjmp really is not much more than exception handling in C.
>>>
>>>        
>> For what it's worth, I think that setjmp/longjmp is not anywhere near as
>> dangerous as people want to make it out to be.  gcc will warn for
>> dangerous uses (and a lot of non-dangerous uses), but generally the
>> difficult problems can be dealt with by moving the setjmp-protected code
>> into a separate function.
>>
>>      
> Can I consider this as ACK for something like the patch blow? :) (with
> proper x86 version of setjmp/longjmp of course).
>    

The setjmp/longjmp implementation should definitely live in arch/*/lib, 
even if kvm is the only user.

-- 
error compiling committee.c: too many arguments to function

