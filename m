Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZJFSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZJFSsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZJFSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:48:21 -0400
Received: from claw.goop.org ([74.207.240.146]:59794 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbZJFSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:48:20 -0400
Message-ID: <4ACB90CF.80906@goop.org>
Date: Tue, 06 Oct 2009 11:47:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [Xen-devel] [PATCH 4/5] x86/fixmap: add a predicate for	usermode
 fixmaps
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-5-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB36DA02000078000182DD@vpn.id2.novell.com>
In-Reply-To: <4ACB36DA02000078000182DD@vpn.id2.novell.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 03:23, Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> 06.10.09 02:50 >>>
>>>>         
>> --- a/arch/x86/include/asm/fixmap.h
>> +++ b/arch/x86/include/asm/fixmap.h
>> @@ -181,6 +181,24 @@ static inline void __set_fixmap(enum fixed_addresses idx,
>>
>> extern void __this_fixmap_does_not_exist(void);
>>
>> +static inline bool user_fixmap(enum fixed_addresses fixmap)
>> +{
>> +	switch (fixmap) {
>> +#ifdef CONFIG_X86_32
>> +	case FIX_HOLE ... FIX_VDSO:
>> +#else
>> +	case VSYSCALL_LAST_PAGE ... VSYSCALL_HPET:
>> +#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
>> +	case FIX_PVCLOCK_TIME_INFO:
>> +#endif
>> +#endif
>> +		return true;
>> +
>> +	default:
>>     
> Isn't that nested #ifdef rather meant to be successive to the 32-/64-bit
> one?
>   

No, because 32-bit doesn't support vsyscall at present.  But I've been
meaning to add a CONFIG_X86_VSYSCALL to make all the vsyscall stuff
conditional on, so if/when 32-bit vsyscall gets done its easy to turn it
all on.

    J
