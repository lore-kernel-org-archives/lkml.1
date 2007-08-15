Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXHOPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXHOPNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762251AbXHOPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:13:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:50208 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761640AbXHOPNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:13:14 -0400
Message-ID: <46C31813.4050404@qumranet.com>
Date: Wed, 15 Aug 2007 18:13:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com>
In-Reply-To: <46C31736.2050001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Andi Kleen escreveu:
>> On Wed, Aug 15, 2007 at 11:18:25AM -0300, Glauber de Oliveira Costa 
>> wrote:
>>>> Didn't we agree this should be a pvops client?
>>>>
>>>> -Andi
>>>>
>>> No. I exposed my reasoning, asked you back, but got no answer.
>>> I'll do it again:
>>>
>>> This operations are just manipulating bits, and are doing no
>>> privileged operations at all. Nothing that can be paravirtualized, in
>>
>> It's talking to a Hypervisor. That is privileged enough.
>> Please do that change. If you add so many more ifdefs it's your
>> duty to keep the overall number low.
>
> Again, this is the code of such function:
>
> static inline int raw_irqs_disabled_flags(unsigned long flags)
> {
>         return !(flags & X86_EFLAGS_IF);
> }
> so all it is doing is getting a parameter (flags), and bitmasking it. 
> It is not talking to any hypervisor. I can't see your point. Unless 
> you are
> arguing that it _should_ be talking to a hypervisor. Is that your point?

It is talking to a hypervisor.  This hypervisor does full 
virtualization, except that it allows the guest to hide eflags.IF inside 
eflags.AC as an optimization (otherwise you need to do binary 
translation to overcome popf silently disregarding IF on the stack).

You can regard eflags.AC as the paravirtualized eflags.IF (Xen for 
example has a per-vcpu memory flag for the same).


-- 
error compiling committee.c: too many arguments to function

