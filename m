Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZHYSG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZHYSG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZHYSG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:06:56 -0400
Received: from claw.goop.org ([74.207.240.146]:45670 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbZHYSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:06:55 -0400
Message-ID: <4A94283C.6000405@goop.org>
Date: Tue, 25 Aug 2009 11:06:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
References: <4A9407B1.6020400@nets.rwth-aachen.de>	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>	 <4A94161A.2020609@nets.rwth-aachen.de> <1251219129.4852.1.camel@penberg-laptop>
In-Reply-To: <1251219129.4852.1.camel@penberg-laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 09:52, Pekka Enberg wrote:
> Hi Arnd,
>
> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
>   
>>> Thanks for doing the bisect! Can we also see your .config also?
>>>       
>> Config for -rc7 is attached. My bisect configs were based on that
>>     
> Thanks! While we wait for the Xen people, you can try the following
> patch to see if we can narrow the bug down to trap_init().
>   

I think there's a problem that the side-effect of this change is that
interrupt initialization comes later, and so the dynamically allocated
arrays are not set up when the first interrupt comes in.

However, this particular change shouldn't have any effect on interrupts
being enabled early, right?

I have a local workaround which simply reverts the arrays back to
statically allocated, but it isn't very satisfactory (large memory hit,
esp if you're not running Xen).

    J
