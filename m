Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbZIDQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbZIDQKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZIDQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:10:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZIDQKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:10:03 -0400
Message-ID: <4AA13BBE.5060501@kernel.org>
Date: Sat, 05 Sep 2009 01:09:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com> <4AA08DD3.5010509@kernel.org> <4AA08ED0.4050206@zytor.com> <4AA0A05B.5010806@kernel.org> <4AA13A8C.2080709@goop.org>
In-Reply-To: <4AA13A8C.2080709@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 16:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> On 09/03/09 22:06, Tejun Heo wrote:
>>>> Heh... here's a naive and hopeful plan.  How about we beg gcc
>>>> developers to allow different segment register and offset in newer gcc
>>>> versions and then use the same one when building with the new gcc?
>>>> This should solve the i386 problem too.  It would be the best as we
>>>> get to keep the separate segment register from the userland.  Too
>>>> hopeful?
>>>>       
>>> I think it's possible to set the register in more recent gcc.  Doing the
>>> sane thing and having a symbol for an offset is probably worse.
>>>     
>> I was thinking about altering the build process so that we can use sed
>> to substitute %gs:40 with %fs:40 while compiling.  If it's already
>> possible to override the register in more recent gcc, no need to go
>> into that horror.
>>   
> 
> Ideally we'd like to get rid of the constant offset too.  If we could
> change it to %[fg]s:__gcc_stack_canary_offset on both 32-bit and 64-bit,
> it would give us a lot more flexibility.  __gcc_stack_canary_offset
> could be weakly defined to 20/40 for backwards compatibility, but we
> could override it to point to a normal percpu variable.

Yeap, being able to do that will also allow using single segment
register on i386 too.  But given that the only overhead we're talking
here is a few more cycles when entering and leving the kernel, I don't
think we need to do anything drastic to optimize this.  I think
converting when gcc provides the feature should be enough.

Thanks.

-- 
tejun
