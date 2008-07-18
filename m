Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYGRWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYGRWvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGRWvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:51:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:34094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYGRWvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GiLOWsESfrFmyDRekVImq2YDcFyL4P341ApsWkSgu5oA4aremF8vhF/Pqbqiy7nmqS
         UYtxNE5T7HlaoB2rD87VD/md0wC7UZFaSujKn42ZMTny0Z/tZaSedXRsCCjtjMZCp05o
         5S8KQ6s/Zb+xuNiu21RCjKwjwmfRTkMJ3+/B8=
Message-ID: <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com>
Date: Fri, 18 Jul 2008 15:51:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Ingo Molnar" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20080718224922.GB4507@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <20080718105259.GY6875@elte.hu>
	 <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
	 <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
	 <20080718210348.GB24373@elte.hu>
	 <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
	 <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
	 <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
	 <20080718224922.GB4507@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 3:49 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, Jul 18, 2008 at 03:42:17PM -0700, Zachary Amsden wrote:
>> On Fri, 2008-07-18 at 15:02 -0700, Maciej W. Rozycki wrote:
>> > On Fri, 18 Jul 2008, Yinghai Lu wrote:
>> >
>> > >   CC      arch/x86/kernel/apic_64.o
>> > > arch/x86/kernel/apic_64.c:170: error: unknown field 'write_atomic'
>> > > specified in initializer
>> > > arch/x86/kernel/apic_64.c:170: error: 'native_apic_mem_write_atomic'
>> > > undeclared here (not in a function)
>> > > arch/x86/kernel/apic_64.c:209: error: unknown field 'write_atomic'
>> > > specified in initializer
>> > > arch/x86/kernel/apic_64.c:209: warning: initialization from
>> > > incompatible pointer type
>> > > make[1]: *** [arch/x86/kernel/apic_64.o] Error 1
>> > > make: *** [arch/x86/kernel] Error 2
>> >
>> >  Just remove the offending initialisers.  They are not needed anymore as
>> > the .write method is now used universally including places where
>> > .write_atomic was.  I just could not stand watching the thing
>> > proliferate...
>>
>> Thank you for cleaning this up Yinghai, but this really begs the
>> question - is having write_atomic REALLY worthwhile?
>
> And this thread is about,  Maciej's cleanup patch which removed
> write_atomic completely :)
>
> Thanks to Maciej who posted this fix. It was on my todo list for
> sometime now!

do we rebase tip/x86/x2apic or rework this patch?

YH
