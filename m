Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbYJIRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbYJIRYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYJIRYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:24:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:64622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbYJIRYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:24:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,383,1220252400"; 
   d="scan'208";a="57471798"
From: "Moore, Robert" <robert.moore@intel.com>
To: Len Brown <lenb@kernel.org>, Matt Mackall <mpm@selenic.com>
CC: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Thu, 9 Oct 2008 10:23:47 -0700
Subject: RE: [PATCH] x86: trim ACPI sleep stack buffer
Thread-Topic: [PATCH] x86: trim ACPI sleep stack buffer
Thread-Index: AckqMz2mzROokeqNQLuP/h3jznEIsAAAHtYg
Message-ID: <4911F71203A09E4D9981D27F9D83085803123361@orsmsx503.amr.corp.intel.com>
References: <1222819957.13453.15.camel@calx>
 <20081009085649.GC29957@atrey.karlin.mff.cuni.cz>
 <1223571381.17706.94.camel@calx>
 <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds like you need a

#define DEFAULT_STACK_SIZE 4096

Somewhere.


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Len Brown
>Sent: Thursday, October 09, 2008 10:20 AM
>To: Matt Mackall
>Cc: Pavel Machek; Ingo Molnar; Linux Kernel Mailing List; linux-
>acpi@vger.kernel.org
>Subject: Re: [PATCH] x86: trim ACPI sleep stack buffer
>
>applied to acpi-test.
>
>thanks Matt,
>-Len
>
>On Thu, 9 Oct 2008, Matt Mackall wrote:
>
>> On Thu, 2008-10-09 at 10:56 +0200, Pavel Machek wrote:
>> > > We've got:
>> > >
>> > > #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
>> > > static char temp_stack[10240];
>> > > #endif
>> > >
>> > > and:
>> > >
>> > > #ifdef CONFIG_SMP
>> > >         stack_start.sp = temp_stack + 4096;
>> > > #endif
>> > >
>> > > ..which suggests we use at most 4k of the stack?
>> >
>> > I guess someone (probably me) was "playing it safe" -- not exactly
>> > remembering if stack grows down or up. I guess it should be safe to
>> > change it... will do that.
>> >
>Pavel
>>
>> I've already got a patch, I was just wondering if there was some obscure
>> architectural reason for it that I wasn't aware of.
>>
>>
>> x86: trim ACPI sleep stack buffer
>>
>> x86_64 SMP suspend to RAM uses a 10k temporary stack for saving the
>> kernel state, but only 4k of it is used. Shrink it to 4k.
>>
>> Signed-off-by: Matt Mackall <mpm@selenic.com>
>>
>> diff -r 73d55a1b6c10 arch/x86/kernel/acpi/sleep.c
>> --- a/arch/x86/kernel/acpi/sleep.c    Wed Oct 08 14:48:45 2008 -0500
>> +++ b/arch/x86/kernel/acpi/sleep.c    Thu Oct 09 11:51:54 2008 -0500
>> @@ -21,7 +21,7 @@
>>  static unsigned long acpi_realmode;
>>
>>  #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
>> -static char temp_stack[10240];
>> +static char temp_stack[4096];
>>  #endif
>>
>>  /**
>>
>> --
>> Mathematics is the supreme nostalgia of our time.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
