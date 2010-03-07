Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0CGJBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:01:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0CGJBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:01:00 -0500
Message-ID: <4B936B27.1050207@redhat.com>
Date: Sun, 07 Mar 2010 11:00:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: john cooper <john.cooper@third-harmonic.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mtosatti@redhat.com,
       zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BB6FA.1000505@oss.ntt.co.jp> <20100301125223.GI16909@redhat.com> <4B8BBE61.3020503@oss.ntt.co.jp> <20100301132609.GJ16909@redhat.com> <4B8C11DC.1060004@third-harmonic.com> <20100302072809.GS16909@redhat.com>
In-Reply-To: <20100302072809.GS16909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 09:28 AM, Gleb Natapov wrote:
> On Mon, Mar 01, 2010 at 02:13:32PM -0500, john cooper wrote:
>    
>> Gleb Natapov wrote:
>>
>>      
>>> Think about what happens if in the middle of
>>> instruction emulation some data from device emulated in userspace is
>>> needed. Emulator should be able to tell KVM that exit to userspace is
>>> needed and restart instruction emulation when data is available.
>>>        
>> setjmp/longjmp are useful constructs in general but
>> IME are better suited for infrequent exceptions vs.
>> routine usage.
>>      
> Exception condition during instruction emulation _is_
> infrequent.

Well, with mmio you'd expect it to happen every read access.

> Although setjmp/longjmp that I know about
> are routine usage. See QEMU TCG main loop or userspace
> thread libraries.
>    

Agreed, nothing magical about it.

>> If the issue is finding some clean and regular way
>> to back out from (and possibly reeneter) logic
>> expressed within nested function invocations, have
>> you considered turning the problem inside out and
>> using a state machine approach?
>>      
> I don't see how state machine will help. But the goal
> is not to rewrite emulator.c (this will no be excepted
> by kvm maintainers), but improve it gradually.
>    

That is orthogonal.  If we decide a state machine is the best 
implementation, then we'll find a way to move over to that.  However, I 
don't think a state machine is a good representation considering some of 
the code paths are very complicated and depend on a many memory accesses 
(e.g. hardware task switches).

-- 
error compiling committee.c: too many arguments to function

