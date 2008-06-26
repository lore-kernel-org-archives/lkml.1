Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYFZIXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYFZIXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYFZIXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:23:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:26140 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYFZIXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DsTIhxiywV3jGNoy2N0uH1SqllygNT4pDPLdUrf3jFhAYDj8hrngGXhEvN31TLzNJ2
         mOiAyYQsa9r1YO2U0+2TocitRX/19ihx+Jeb2RsrueWlpr96wXbq+aZBieg9nzJrtG/U
         Ou6tVvOrk/b6xGrb7CIgxYt+NyEad6bxctaTI=
Message-ID: <86802c440806260123t3da4760bnc7dcef8d0251c983@mail.gmail.com>
Date: Thu, 26 Jun 2008 01:23:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not set
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080624121234.GB5642@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200806191213.10312.yhlu.kernel@gmail.com>
	 <200806191215.01538.yhlu.kernel@gmail.com>
	 <200806200742.36226.yhlu.kernel@gmail.com>
	 <20080624121234.GB5642@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 5:12 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> we can not use acpi=off, acpi=noirq and pci=noacpi when mps support is
>> not there
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/kernel/acpi/boot.c |   12 ++++++++++++
>>  arch/x86/kernel/setup_32.c  |    2 ++
>>  arch/x86/kernel/setup_64.c  |    2 ++
>>  include/linux/acpi.h        |    5 +++++
>>  4 files changed, 21 insertions(+)
>>
>> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
>> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
>> @@ -1740,6 +1740,18 @@ static int __init parse_pci(char *arg)
>>  }
>>  early_param("pci", parse_pci);
>>
>> +void __init acpi_mps_check(void)
>> +{
>> +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
>> +/* mptable code is not built-in*/
>> +     if (acpi_disabled || acpi_noirq) {
>> +             printk(KERN_ERR "MPS support code is not built-in\n",
>> +                    "so can not use acpi=off or acpi=noirq or pci=noacpi\n");
>> +             panic("MPS support is not built-in\n");
>> +     }
>> +#endif
>
> I'd say this is good enough reason not to make X86_MPPARSE optional.
>

new patch in tip/master, it will disable smp instead of panic.

YH
