Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYJ3LBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYJ3LBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYJ3LBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:01:08 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27520 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYJ3LBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:01:06 -0400
Message-Id: <4909A212.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 30 Oct 2008 11:01:22 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: simplify X86_MPPARSE config option
References: <49099CB0.76E4.0078.0@novell.com>
 <20081030105146.GG3569@elte.hu>
In-Reply-To: <20081030105146.GG3569@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 30.10.08 11:51 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
>> ---
>>  arch/x86/Kconfig |   12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
>> 
>> --- linux-2.6.28-rc2/arch/x86/Kconfig	2008-10-30 11:03:18.000000000 +0100
>> +++ 2.6.28-rc2-x86-kconfig-cleanup/arch/x86/Kconfig	2008-10-21 13:57:07.000000000 +0200
>> @@ -235,21 +235,13 @@ config X86_FIND_SMP_CONFIG
>>  	def_bool y
>>  	depends on X86_MPPARSE || X86_VOYAGER
>>  
>> -if ACPI
>>  config X86_MPPARSE
>> -	def_bool y
>> -	bool "Enable MPS table"
>> +	bool "Enable MPS table" if ACPI
>> +	default y
>>  	depends on X86_LOCAL_APIC
>>  	help
>>  	  For old smp systems that do not have proper acpi support. Newer systems
>>  	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
>> -endif
>> -
>> -if !ACPI
>> -config X86_MPPARSE
>> -	def_bool y
>> -	depends on X86_LOCAL_APIC
>> -endif
>
>hm, that's not an equivalent change. But i guess we can do this, it 
>sure looks like a cleaner construct.

Why is it not equivalent (apart from the help portion, which doesn't
matter when the prompt isn't visible)?

Jan

