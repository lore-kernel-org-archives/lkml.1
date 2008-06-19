Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYFSRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYFSRj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYFSRjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:39:18 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:16609 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYFSRjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sXGQNFA3yDk08AwFOlgX041ia9obIR5dvOTzsYnwZYhlbAde7o8dOM31C2o4dheaXa
         8qN2tWw7DwBR2ODDaPBOWqt3Rbj362G+aLaMmCaiUf6yWjFLV0ERSMpbOtvbcNrlmLpH
         QgqqpHOUdwRT0/Tdg44IIHMp41QKcOxKsxP0A=
Message-ID: <86802c440806191039q5c6a2266p82d319a61a3bba3c@mail.gmail.com>
Date: Thu, 19 Jun 2008 10:39:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: let MPS support selectable
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Exner" <dex@dragonslave.de>, "Len Brown" <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200806181432.57204.yhlu.kernel@gmail.com>
	 <200806181729.31464.yhlu.kernel@gmail.com>
	 <200806190018.45944.yhlu.kernel@gmail.com>
	 <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 8:10 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Thu, 19 Jun 2008, Yinghai Lu wrote:
>
>> @@ -233,6 +233,19 @@ config SMP
>>
>>         If you don't know what to do here, say N.
>>
>> +config X86_FIND_SMP_CONFIG
>> +     def_bool y
>> +     depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
>> +     depends on X86_32
>> +
>> +config X86_MPPARSE
>> +     def_bool y
>> +     bool "Enable MPS table"
>> +     depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
>> +     help
>> +       For old smp systems that do not have proper acpi support. Newer systems
>> +       (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
>> +
>>  choice
>>       prompt "Subarchitecture Type"
>>       default X86_PC
>
>  First of all you want to make sure at least one of ACPI and X86_MPPARSE
> is enabled if X86_LOCAL_APIC or you risk a known-broken kernel
> configuration, e.g. SMP which has no slightest chance to work.
>
>  Personally I'd be happy to see CONFIG_ACPI_BOOT we used to have at one
> point back just so that you can use ACPI tables to run an SMP system
> without the need to pull all the power management stuff.  Useful if the MP
> table is broken beyond recovery.  I am assuming it has been removed for a
> reason though.

thanks. will try to add CONFIG_ACPI_BOOT...

YH
