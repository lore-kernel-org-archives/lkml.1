Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYAOUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYAOUqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYAOUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:45:54 -0500
Received: from gw.goop.org ([64.81.55.164]:51043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYAOUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:45:53 -0500
Message-ID: <478D1B6F.8020003@goop.org>
Date: Tue, 15 Jan 2008 12:45:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Folding _PAGE_PWT into _PAGE_PCD (was Re: unify pagetable accessors
 patch causes double fault II)
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu> <478CEA82.9010606@goop.org> <20080115203018.GA19746@linux-os.sc.intel.com>
In-Reply-To: <20080115203018.GA19746@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> On Tue, Jan 15, 2008 at 09:16:50AM -0800, Jeremy Fitzhardinge wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> -#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
>>> -#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
>>> -#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
>>> -#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
>>> -#define _PAGE_PCD	((_AC(1, UL)<<_PAGE_BIT_PCD) | _PAGE_PWT)
>>>  
>>>       
>> BTW, I just noticed that _PAGE_PWT has been folded into _PAGE_PCD.  This 
>> seems like a really bad idea to me, since it breaks the rule that 
>> _PAGE_X == 1 << _PAGE_BIT_X.  I can't think of a specific place where 
>> this would cause problems, but this kind of non-uniformity always ends 
>> up biting someone in the arse.
>>
>> I think having a specific _PAGE_NOCACHE which combines these bits is a 
>> better approach.
>>
>>    J
>>     
>
> How about the patch below. It defines new _PAGE_UC. One concern is drivers
> continuing to use _PAGE_PCD and getting wrong attributes. May be we need to
> rename _PAGE_PCD to catch those errors as well?
>   

Sure, looks fine.  I would have said that _NOCACHE matches current usage 
better, but if it makes more sense to have _UC and _WC then that's fine 
with me.

I guess renaming _PAGE_BIT_PCD to _PAGE_BIT__PCD and the corresponding 
_PAGE__PCD might be reasonable if you think there's a chance of new 
misusers appearing (I guess something like out of tree DRI/proprietary 
patches are a source of that).

    J

