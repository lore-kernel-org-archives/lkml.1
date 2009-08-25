Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZHYSaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZHYSaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZHYSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:30:19 -0400
Received: from claw.goop.org ([74.207.240.146]:55731 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHYSaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:30:18 -0400
Message-ID: <4A942DB9.3020209@goop.org>
Date: Tue, 25 Aug 2009 11:30:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
References: <4A9407B1.6020400@nets.rwth-aachen.de> <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com> <4A94161A.2020609@nets.rwth-aachen.de> <1251219129.4852.1.camel@penberg-laptop> <4A94242E.30309@nets.rwth-aachen.de> <1251223399.13451.5.camel@penberg-laptop> <4A942BDD.70303@nets.rwth-aachen.de> <20090825182510.GA6903@elte.hu>
In-Reply-To: <20090825182510.GA6903@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 11:25, Ingo Molnar wrote:
> * Arnd Hannemann <hannemann@nets.rwth-aachen.de> wrote:
>
>   
>> Pekka Enberg wrote:
>>     
>>> On Tue, 2009-08-25 at 19:49 +0200, Arnd Hannemann wrote:
>>>       
>>>> Hi Pekka,
>>>>
>>>> Pekka Enberg wrote:
>>>>         
>>>>> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
>>>>>           
>>>>>>> Thanks for doing the bisect! Can we also see your .config
>>>>>>> also?
>>>>>>>               
>>>>>> Config for -rc7 is attached. My bisect configs were based on
>>>>>> that
>>>>>>             
>>>>> Thanks! While we wait for the Xen people, you can try the
>>>>> following patch to see if we can narrow the bug down to
>>>>> trap_init().
>>>>>           
>>>> Yes seems to be trap_init(). -rc7 with this patch applied boots up
>>>> to the prompt.
>>>>         
>>> Thanks for testing! Ingo, what do you think of the following patch?
>>> AFAICT, x86-32 is the only architecture playing with traps in
>>> mem_init() so this should be the safest fix for 2.6.31.
>>>       
>> Hmm, -rc7 + this fix does not work for me :-/
>> Still hangs before any output...
>>     
> does earlyprintk=vga tell you anything about precisely where it 
> hangs?
>   

It's a Xen domain, so it should be earlyprintk=xen

    J
