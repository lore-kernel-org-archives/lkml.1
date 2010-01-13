Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907Ab0AMFZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0AMFZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070Ab0AMFZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:25:23 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:38639 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab0AMFZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fvsrzpj5AU4TVtyiNV0kthIxQo3ketPafnyFwHZOX2jF5ok+OCEuX2mXIC7lOWvE+s
         Us/CyQ0XrbSobEYfEnR7JLyD8Qu7k+GhGYgZhpOmKPrDHW4BTAM+W1Fhui0xtRhSXzbN
         BYTqyHjzad7UTCHj+3L+jyZoCbTXoH6hL8k7g=
MIME-Version: 1.0
In-Reply-To: <20100112080600.392c14cd@infradead.org>
References: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
	 <20100112080600.392c14cd@infradead.org>
Date: Wed, 13 Jan 2010 13:25:20 +0800
Message-ID: <ce2c83091001122125i6aac119fk470621fb6b1c2b4c@mail.gmail.com>
Subject: Re: Did we really need to clear the IF flag at prepare_singlestep() 
	of x86 kprobes?
From: Dongdong Deng <libfetion@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, jkenisto@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:06 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 12 Jan 2010 19:09:35 +0800
> Dongdong Deng <libfetion@gmail.com> wrote:
>
>> Hi Kprobe experts,
>>
>> I have a doubt about the handling "X86_EFLAGS_IF" at
>> prepare_singlestep(), Could you give me some suggestions?
>
>
> iirc it was a security thing; we used to have some exploits
> due to the linux-abi entry points which caused a mess, and this
> was put there as defensive programming.

Hi Arjan,

Thanks for your explain. :)

Do you means that the user will modify the IF? for example: through
"p->pre_handler(p, regs)" .

But I couldn't image the affect that if user modify the IF flag, could
you give me a detail info about security thing?


BTW:

Before linux 2.5, the debug tarp was initalized as trap gate:

linux-2.4.37/arch/i386/kernel/traps.c:966:	set_trap_gate(1,&debug);

I know kprobes have a long history,  Is it possible that the interrupt
flag of kprobes was introduced at that time?


Thanks,
Dongdong




>
> I could totally misremember this as well of course.
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
