Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXCPTiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXCPTiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXCPTiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:38:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43153 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbXCPTiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:38:12 -0400
Message-ID: <45FAF222.9070900@vmware.com>
Date: Fri, 16 Mar 2007 11:38:10 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <m17itho10v.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17itho10v.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I'm not quite familiar with the context.  And I'm to lazy to look right now.
> What is the difference with COMPAT_VDSO that it doesn't do relocation?
> What are we preserving?
>   

COMPAT_VDSO causes the link address to be fixed at compile time to match 
the virtual address of the VDSO.  !COMPAT_VDSO just links at zero.

> The practical question here is if we already have all of the relocation logic
> for the VDSO why do we need to add more?
>   

There wasn't relocation logic before, the VDSO just got remapped to a 
different virtual address without any relocation at all.  Which is safe, 
because it is all hand-coded assembly, relocatable code.  But not 
complete, since the ELF headers don't have any fixup applied for the 
relocation, and there are broken linkers which look at the ELF headers 
and assert fail if ph->p_vaddr != _rtld_local._dl_sysinfo_dso; these 
broken dynamic linkers are what COMPAT_VDSO is protecting.

> I'm tempted to rant on the pure insanity of address space randomization but
> that is a whole other issue...
>   

Firesticks in ant nests is all I'm saying about that.

Zach
