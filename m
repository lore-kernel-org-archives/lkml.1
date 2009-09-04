Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZIDP7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZIDP7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZIDP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:59:42 -0400
Received: from claw.goop.org ([74.207.240.146]:60343 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZIDP7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:59:41 -0400
Message-ID: <4AA1396E.5020300@goop.org>
Date: Fri, 04 Sep 2009 08:59:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org>	<tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org>	<4AA02687.9080406@zytor.com>	<4AA02B02.7080101@goop.org>	<4AA031DE.2070109@zytor.com>	<20090903211805.GB12566@elte.hu> <20090904071524.0a7267ce@infradead.org>
In-Reply-To: <20090904071524.0a7267ce@infradead.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/09 07:15, Arjan van de Ven wrote:
> On Thu, 3 Sep 2009 23:18:05 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>     
>>> On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
>>>       
>>>> Two problems:
>>>>
>>>>     * gcc generates %gs: references for stack-protector, but we
>>>> use %fs for percpu data (because restoring %fs is faster if it's
>>>> a null selector; TLS uses %gs).  I guess we could use %fs if
>>>>       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it
>>>> (though that has some fiddly ramifications for things like
>>>> ptrace).
>>>>         
>>> Well, by touching two segments we're getting the worst of both 
>>> worlds, so at least assuming some significant number of real-world 
>>> deployments use CC_STACKPROTECTOR, we really don't want to 
>>> pessimize that case too much.
>>>       
>> Fedora has stackprotector enabled so it's used in a widespread way.
>>
>> 	Ingo
>>     
> the other issue is that afaik we want the kernel to use the other
> register than userspace does...
>   

We do for percpu (%fs), but gcc always generates %gs references for
stack-protector.  The difference between "pop %seg" for a null vs
non-null selector was fairly small (a couple of cycles), so using %gs
when stack-protector is enabled isn't a huge deal.  To put it another
way, calling one stack-protected function in kernel mode would probably
make up the difference between using %fs vs %gs.

    J
>
>   

