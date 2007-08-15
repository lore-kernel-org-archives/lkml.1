Return-Path: <linux-kernel-owner+w=401wt.eu-S1765019AbXHOQWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765019AbXHOQWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXHOQVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:21:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314AbXHOQVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:21:50 -0400
Message-ID: <46C3283B.5090804@redhat.com>
Date: Wed, 15 Aug 2007 13:22:19 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>, kiran@scalemp.com,
       shai@scalemp.com
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com> <20070815163640.GJ3406@bingen.suse.de>
In-Reply-To: <20070815163640.GJ3406@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen escreveu:
> On Wed, Aug 15, 2007 at 12:09:42PM -0300, Glauber de Oliveira Costa wrote:
>> Again, this is the code of such function:
>>
>> static inline int raw_irqs_disabled_flags(unsigned long flags)
>> {
>>         return !(flags & X86_EFLAGS_IF);
>> }
>> so all it is doing is getting a parameter (flags), and bitmasking it. It 
>> is not talking to any hypervisor. I can't see your point. Unless you are
>> arguing that it _should_ be talking to a hypervisor. Is that your point?
> 
> vSMP is a hypervisor based architecture. For some reason that is not
> 100% clear to me, but Kiran or Shai can probably explain, it needs this 
> additional bit in EFLAGS when interrupts are disabled. That gives
> it some hints and then it goes somehow faster. That is clearly
> paravirtualization.
> 
> Since paravirtops is designed to handle such hooks cleanly I request
> that you move vSMP over to it or work with the vSMP maintainers to 
> do that. Otherwise we have two different ways to do paravirtualization 
> which is wrong.
> 

Thanks for the explanation, Andi. I understand it much better now, and 
agree with you.

As alternatives what we have now, we can either keep the paravirt_ops as 
it is now for the native case, just hooking the vsmp functions in place 
of the normal one, (there are just three ops anyway), refill the 
paravirt_ops entirely in somewhere like vsmp.c, or similar (or maybe 
even assigning paravirt_ops.fn = vsmp_fn on the fly, but early enough).

Maybe we could even make VSMP depend on PARAVIRT, to make it sure it is 
completely a paravirt client.

But as you could see, my knowledge of vsmp does not go that far, and I 
would really like to have input from the vsmp guys prior to touch 
anything here.

