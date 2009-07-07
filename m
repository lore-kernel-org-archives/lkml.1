Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZGGOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZGGOX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZGGOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:23:20 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:61563 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZGGOXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vMZjsBrZ9KOD3e7lNMKwBVMVrdRqGdRGxllu3YsdHF6tP22TUniaZeRqz4OcJRq7b/
         lef+435KPX2us95dY4t3H3aBn3CFYc2viwTpaCGFcocJALZkY6Lqq5rOkaURSMoCEWdG
         NON5il77v1w2L3qHteNlH3g3mWFpZ9oHb4HTA=
MIME-Version: 1.0
In-Reply-To: <2375c9f90907070705p1ae6ebe4x61bda34dd072c1c@mail.gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.5zE.DjASKB@chimera> 
	<a5d9929e0907011336g31599a29hca3c204f1b53b775@mail.gmail.com> 
	<2375c9f90907070705p1ae6ebe4x61bda34dd072c1c@mail.gmail.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 15:22:57 +0100
Message-ID: <a5d9929e0907070722j563cf485j720274e776f736e4@mail.gmail.com>
Subject: Re: [Bug #13660] Crashes during boot on 2.6.30 / 2.6.31-rc, random 
	programs
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already testing the changes, just to see if something else breaks.

Any special notes on the patch (a basic guideline info on patches
would be great, just so i dont mess it up)? Never submited one before.

Joao Correia

On Tue, Jul 7, 2009 at 3:05 PM, Américo Wang<xiyou.wangcong@gmail.com> wrote:
> On Thu, Jul 2, 2009 at 4:36 AM, Joao Correia<joaomiguelcorreia@gmail.com> wrote:
>> No formal patch has been sent yet, that i am aware of. I have made
>> some changes following suggestion by Americo Wang advise, to the
>> following:
>>
>> (patch by Ingo)
>>
>> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
>> index 699a2ac..031f4c6 100644
>> --- a/kernel/lockdep_internals.h
>> +++ b/kernel/lockdep_internals.h
>> @@ -65,7 +65,7 @@ enum {
>>  * Stack-trace: tightly packed array of stack backtrace
>>  * addresses. Protected by the hash_lock.
>>  */
>> -#define MAX_STACK_TRACE_ENTRIES        262144UL
>> +#define MAX_STACK_TRACE_ENTRIES        1048576UL
>>
>>  extern struct list_head all_lock_classes;
>>  extern struct lock_chain lock_chains[];
>>
>> and afterwards, a new bug popped up, solved by changing
>>
>> include/linux/sched.h
>>
>> # define MAX_LOCK_DEPTH 48UL
>>
>> to
>>
>> # define MAX_LOCK_DEPTH 96UL
>>
>>
>> I have now found a third limit bug, related to MAX_LOCKDEP_CHAINS,
>> which was hidden so far, which im trying to raise and replicate. This
>> is being discussed in detail in another message exchange on the lkml,
>> between me and Americo.
>
> How about changing MAX_LOCKDEP_CHAINS_BITS to 16?
>
> kernel/lockdep_internals.h:59:#define MAX_LOCKDEP_CHAINS_BITS   15
>
> And can you make a complete patch and send it to lkml with Peter and me
> Cc'ed?
>
> Thank you!
>
