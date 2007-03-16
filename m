Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXCPFKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXCPFKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 01:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXCPFKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 01:10:50 -0400
Received: from gw.goop.org ([64.81.55.164]:44292 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbXCPFKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 01:10:50 -0400
Message-ID: <45FA26DA.7020109@goop.org>
Date: Thu, 15 Mar 2007 22:10:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org> <45FA16FE.7010805@vmware.com>
In-Reply-To: <45FA16FE.7010805@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Well testing that is not so fun.  I installed SUSE Pro 9.0, and
> strings on ld.so contains the magic at_sysinfo assert!  But it doesn't
> install TLS libraries, so I'll have to install them by hand.
>
> In works - in theory.  Look, a puppy!
>
> Scratchbox is rumored to produce the fabled assertion even on modern
> distros by installing its own toolchain which includes the dreaded glibc.

I think Andi and Andrew have boxes which are afflicted.

> I'm playing safe.  Binary identical relocation to 0xffffe000 was my goal.

Yeah, fair enough.  But as Eric likes to keep pointing out, an
executable ELF file need not have any sections at all, so the only safe
course for anything "real" is via the section headers.

So I guess the right thing to do is relocate the dynamic stuff via
PT_DYNAMIC, and relocate the symtab if its present.

>>> +        } else if (strcmp(secstrings+sechdrs[i].sh_name,
>>> ".dynamic") == 0) {
>>> +            Elf32_Dyn *dyn = (void *)hdr + sechdrs[i].sh_offset;
>>> +            int tag;
>>> +            while ((tag = (++dyn)->d_tag) != DT_NULL)
>>>       
>>
>> Um, no.
>>   
>
> Walk based on size instead?

No, I was just complaining about the embedded assignment, before dinner,
so I was overly terse.

    J
