Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXB1NKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXB1NKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbXB1NKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:10:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59918 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbXB1NKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:10:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<45E531AE.5050300@ens-lyon.org>
Date: Wed, 28 Feb 2007 06:09:44 -0700
In-Reply-To: <45E531AE.5050300@ens-lyon.org> (Brice Goglin's message of "Wed,
	28 Feb 2007 08:39:26 +0100")
Message-ID: <m1hct6ig2v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin <Brice.Goglin@ens-lyon.org> writes:

> Linus Torvalds wrote:
>> Oh well.. I'm not very proud of this, because quite frankly, -rc2 has way 
>> more changes than I really like.
>>   
>
> Hi Linus,
>
> rc2 fails to build on my thinkpad t43:
>
>   CC      arch/i386/kernel/io_apic.o
> arch/i386/kernel/io_apic.c: In function 'setup_IO_APIC_irqs':
> arch/i386/kernel/io_apic.c:1357: error: 'struct irq_desc' has no member
> named 'affinity'
> arch/i386/kernel/io_apic.c: In function 'io_apic_set_pci_routing':
> arch/i386/kernel/io_apic.c:2878: error: 'struct irq_desc' has no member
> named 'affinity'
> make[1]: *** [arch/i386/kernel/io_apic.o] Error 1
> make: *** [arch/i386/kernel] Error 2
>
> The problem is caused by affinity being within #ifdef SMP in struct
> irq_desc in irq.h:
> #ifdef CONFIG_SMP
>         cpumask_t               affinity;
>         unsigned int            cpu;
> #endif
>
> I don't know whether the whole functions or just a single line should be
> placed under #ifdef CONFIG_SMP. Eric (in CC) will know better than I do.

Yes. I goofed, and missed that stupid case.  The offending lines
should just die.  Patch already sent to Linus.  

Eric
