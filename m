Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYGRQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYGRQ0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYGRQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:25:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:52610 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYGRQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hqq37z1nvxHQbDwy3ofDSngDwCEqPgDBVafiFg/9EWjTqnxUt6WTyZDe54awP4mwYy
         otnCTWd21U/wJaSwHRSIVfdZJjg+LDSGT7Po8LAWJSLeWeZh6vY9rQo1T8HzxNFWYxxv
         zSgMXoz1igyG67ocPZndrBRhUGkz3krZkFLzo=
Message-ID: <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:25:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20080718105259.GY6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <20080718105259.GY6875@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 3:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
>
>>  Use alternatives to select the workaround for the 11AP Pentium
>> erratum for the affected steppings on the fly rather than build time.
>> Remove the X86_GOOD_APIC configuration option and replace all the
>> calls to apic_write_around() with plain apic_write(), protecting
>> accesses to the ESR as appropriate due to the 3AP Pentium erratum.
>> Remove apic_read_around() and all its invocations altogether as not
>> needed.  Remove apic_write_atomic() and all its implementing backends.
>> The use of ASM_OUTPUT2() is not strictly needed for input constraints,
>> but I have used it for readability's sake.
>
> wow, impressive patch!
>
>>  I had the feeling no one else was brave enough to do it, so I went
>> ahead and here it is.  Verified by checking the generated assembly and
>> tested with both a 32-bit and a 64-bit configuration, also with the
>> 11AP "feature" forced on and verified with gdb on /proc/kcore to work
>> as expected (as an 11AP machines are quite hard to get hands on these
>> days).  Some script complained about the use of "volatile", but
>> apic_write() needs it for the same reason and is effectively a
>> replacement for writel(), so I have disregarded it.
>
> kudos for pulling this off :-)
>
> applied to tip/x86/apic. This will interact with tip/x86/x2apic but that
> topic is being worked on anyway. The interaction should be trivial.

it seems we should start apic related merging after x2apic get merged?

YH
