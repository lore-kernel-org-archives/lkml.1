Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbYETLev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbYETLev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYETLem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:34:42 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:55619
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYETLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:34:41 -0400
Message-ID: <4832B74F.5040402@qumranet.com>
Date: Tue, 20 May 2008 14:34:39 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <87k5hpgqwa.fsf@basil.nowhere.org>
In-Reply-To: <87k5hpgqwa.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity <avi@qumranet.com> writes:
>
>   
>> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
>> pointers in order to trap erronous use of freed list_heads.  Unfortunately
>> userspace can arrange for those pointers to actually be dereferencable,
>> potentially turning an oops to an expolit.
>>
>> To avoid this allow architectures (currently x86_64 only) to override
>> the default values for these pointers with truly-undereferncable values.
>> This is easy on x86_64 as the virtual address space is smaller than
>> the range spanned by pointer values.
>>     
>
> Hmm, thought I had sent a reply earlier, but don't see it so again.
> My apologies if you see it twice.
>   

No, this is the first one I see.

> The problem with your address values is that they're non canonical
> and will result in a #GP, not #PF and oops handler cannot display
> the address which will make them much less obvious.
>
> I would rather use a guaranteed to be unmapped but canonical
> address like in the ffffc10000000000 - ffffc1ffffffffff range
> so that you still get page faults.
>   

Makes sense.  I'll send out v3.

Is there a similar range on i386?

-- 
error compiling committee.c: too many arguments to function

