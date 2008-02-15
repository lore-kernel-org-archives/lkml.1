Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbYBOOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbYBOOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYBOOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:07:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58213 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYBOOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:07:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com>
	<20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com>
	<47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu>
	<m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com>
	<20080207121719.GA29279@hmsreliant.think-freely.org>
	<20080207122404.GA8195@elte.hu>
	<20080208161422.GA32204@hmsreliant.think-freely.org>
	<20080208164544.GA23772@redhat.com>
	<20080212210816.GA1862@hmsreliant.think-freely.org>
Date: Fri, 15 Feb 2008 07:02:28 -0700
In-Reply-To: <20080212210816.GA1862@hmsreliant.think-freely.org> (Neil
	Horman's message of "Tue, 12 Feb 2008 16:08:16 -0500")
Message-ID: <m1lk5m9v2j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

>> 
>> Neil, is it possible to do some serial console debugging to find out
>> where exactly we are hanging? Beats me, what's that operation which can
>> not be executed while being in NMI handler and makes system to hang. I am
>> also curious to know if it is nested NMI case.
>> 
>> Thanks
>> Vivek
>> 
>
>
> Hey-
> 	Some intermediate results:
>
> I've instrumented head.S in the kernel with the following code:
> #define SEROUT(z) \     
> mov $0x3F8,%dx;\
> movb z,%al;\
> outb %dx
>
>
> And peppered different ascii characters throughout the startup code from
> startup_32 to right before the jump to start_kernel.  When I panic the system
> via an:
> echo c > /proc/sysrq_trigger
> I see an appropriate sequence of characters on the serial console
>
> When I panic the box by forcing an NMI watchdog timeout however, I see nothing.
>  The machine will either hang, or reset into the bios.  I think this is
> reasonably conclusive in its indication that we're not getting into the second
> kernel when this problem occurs.  Next I'll instrument the purgatory code in a
> simmilar way.

My apologies for the late reply.  You should be able to use the --console-serial
option to kexec to get output from purgatory, which will catch everything
except a little bit of the assembly stub.  purgatory even has a stripped down
version of printf you can call.

Eric
