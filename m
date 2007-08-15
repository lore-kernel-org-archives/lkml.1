Return-Path: <linux-kernel-owner+w=401wt.eu-S1765139AbXHOPJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765139AbXHOPJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763897AbXHOPIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:08:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764713AbXHOPIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:08:38 -0400
Message-ID: <46C31736.2050001@redhat.com>
Date: Wed, 15 Aug 2007 12:09:42 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de>
In-Reply-To: <20070815154243.GH3406@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen escreveu:
> On Wed, Aug 15, 2007 at 11:18:25AM -0300, Glauber de Oliveira Costa wrote:
>>> Didn't we agree this should be a pvops client?
>>>
>>> -Andi
>>>
>> No. I exposed my reasoning, asked you back, but got no answer.
>> I'll do it again:
>>
>> This operations are just manipulating bits, and are doing no
>> privileged operations at all. Nothing that can be paravirtualized, in
> 
> It's talking to a Hypervisor. That is privileged enough.
> Please do that change. If you add so many more ifdefs it's your
> duty to keep the overall number low.

Again, this is the code of such function:

static inline int raw_irqs_disabled_flags(unsigned long flags)
{
         return !(flags & X86_EFLAGS_IF);
}
so all it is doing is getting a parameter (flags), and bitmasking it. It 
is not talking to any hypervisor. I can't see your point. Unless you are
arguing that it _should_ be talking to a hypervisor. Is that your point?

If it is the case, please tell me why. My current understanding is that 
we want to keep few changes from the normal kernel. So there is not too 
much reason for it.
