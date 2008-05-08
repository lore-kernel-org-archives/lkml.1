Return-Path: <linux-kernel-owner+w=401wt.eu-S1762513AbYEHKRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762513AbYEHKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYEHKQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:16:55 -0400
Received: from gw.goop.org ([64.81.55.164]:41151 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbYEHKQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:16:54 -0400
Message-ID: <4822D30E.5010506@goop.org>
Date: Thu, 08 May 2008 11:16:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
References: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<4822AA6F.5040703@cn.fujitsu.com>	<20080508163039.0EF4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080508012957.c778c8e7.akpm@linux-foundation.org>
In-Reply-To: <20080508012957.c778c8e7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 08 May 2008 16:31:29 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>   
>>> KOSAKI Motohiro wrote:
>>>       
>>>> Now, call_usermodehelper_setup() use GFP_ATOMIC.
>>>> but it is slighly odd.
>>>> because call_usermodehelper() is always called process context.
>>>>
>>>>         
>>> Are you sure? I found the following call chain:
>>>
>>>   static irqreturn_t power_handler(int irq, void *dev_id)
>>>   ->orderly_poweroff(true);
>>>     ->call_usermodehelper_setup()
>>>       
>> sorry, you are right.
>> I'll make patch again.
>>     
>
> How many times do we have to make this mistake :(
>
> Only the caller knows what allocation mode the callee can use. 
> call_usermodehelper_setup() should be extended to take a gfp_t argument.
>   

Yeah, but making the caller need to know about the internal 
implementation details of the callee (ie, whether it needs to allocate 
memory or not) leads to pretty warty interfaces.  In this case, you 
could push the gfp_t up to the call_usermodehelper_setup() level, but 
pushing it any higher wouldn't make much sense.

Not that I have a better answer.

    J
