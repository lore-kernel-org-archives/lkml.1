Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYGVSkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYGVSkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGVSkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:40:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:29759 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYGVSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DTBgLsU9MVVcjuIdcY4qOUng1sCvG2dH3+UHM7OfU+4zKzyjm7z0JunKI0a7r84X3q
         O86mJxmW2AQ8QAAxoCNsiD0pb2V+45sRccI+jWYX/8uyFXrVBv4558TYucccfYufMt+N
         0IVF5RwIej+BljzeFsJFS4EFDEX7uZxYxnJj4=
Message-ID: <86802c440807221140o20dcc31fjc10f86a22a1125bb@mail.gmail.com>
Date: Tue, 22 Jul 2008 11:40:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jack Steiner" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080722181056.GD14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807211836.27282.yhlu.kernel@gmail.com>
	 <200807212208.22116.yhlu.kernel@gmail.com>
	 <20080722175757.GC14380@linux-os.sc.intel.com>
	 <86802c440807221105s77372df8re2e59440a8f644bd@mail.gmail.com>
	 <20080722181056.GD14380@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:10 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Tue, Jul 22, 2008 at 11:05:17AM -0700, Yinghai Lu wrote:
>> On Tue, Jul 22, 2008 at 10:57 AM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>> > Yinghai, though not directly realted to this probe cleanup, what is this
>> > 'max_physical_apicid' doing.
>> >
>> > I don't understand the need for this commit.
>> >
>> >> commit e0da33646826b66ef933d47ea2fb7a693fd849bf
>> >> Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> >> Date:   Sun Jun 8 18:29:22 2008 -0700
>> >>
>> >>     x86: introduce max_physical_apicid for bigsmp switching
>> >>
>> >>     a multi-socket test-system with 3 or 4 ioapics, when 4 dualcore cpus or
>> >>     2 quadcore cpus installed, needs to switch to bigsmp or physflat.
>> >>
>> >>     CPU apic id is [4,11] instead of [0,7], and we need to check max apic
>> >>     id instead of cpu numbers.
>> >
>> > for logical flat, it really shouldn't matter how large the physical apic id
>> > is. In logical flat, OS programs the LDR and the limitation is the
>> > number of cpu's which is '8'.
>>
>> before i clean up 32bit, 64bit already used max_physical_apicid to
>> check if need to switch to physflat.
>
> No. It was introduced by your commit e0da33646826b66ef933d47ea2fb7a693fd849bf
>
> we were using num_possible_cpus > 8 check before.

yes. 64bit is changed to use max_phys_apicid at same patch

>
>> for 32bit, if not switch to bigsmp, cpu with physical apic id >=8 can
>> not be started by BSP.
>
> why?

could be apic mode is set to phys flat mode by BIOS.

get
APIC error (0x40)...

that is the reason for introducing max_phys_apicid.
