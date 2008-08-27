Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYH0XX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYH0XX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYH0XXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:23:21 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60807 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYH0XXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SRqs3pAMO/Py5Duk55xO19hoaswGNsPjVB/KroIcoMLKkIG+ZQgfi5B+8PegZzUmkO
         lDg0i2nx9RyEwdirn8J1kaV6zLXCk0RFSWbOjD3pBftGKKW2qM6/5w6eTUZJYcwZ4zC4
         EJPU/z6RpMhaLR6gIbYsprxKVEkEpTG6Ayx1w=
Message-ID: <86802c440808271623oc1ed5f1n8519fa7be9d1e301@mail.gmail.com>
Date: Wed, 27 Aug 2008 16:23:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200808271541.11546.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <914225.91320.qm@web82104.mail.mud.yahoo.com>
	 <20080825073125.GA27950@elte.hu>
	 <86802c440808250100g15b056e0l359e83c6a8ee488b@mail.gmail.com>
	 <200808271541.11546.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 3:41 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Monday, August 25, 2008 1:00 am Yinghai Lu wrote:
>> On Mon, Aug 25, 2008 at 12:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >> this one should work. please apply this one only.
>> >>
>> >> YH
>> >>
>> >> [PATCH] x86: check hpet with BAR v2
>> > - plus a more highlevel approach would be nice as well i think - making
>> >  sure that the hpet driver runs before any of the PCI code, and
>> >  inserting a special "sticky" resource there which would keep any
>> >  potential followup generic PCI resource that overlaps this resource
>> >  untouched. (with a proper kernel warning emitted as well - such
>> >  situations are likely BIOS bugs.)
>>
>> yes, can remove that late_initcall tricky code to insert resource for
>> lapic and ioapic, and mmconfig etc.
>
> I agree, a higher level way of dealing with resource reservation might be
> nice.

1. insert the lapic, ioapic, mmconf mmio address into resource tree at first...
2. later when we fail to request_resource for one BAR res of pci dev,
call check_resource(.., res) to see if could find some res with the
same range and the sticky flag.
if so will insert BAR resource for the device forcibly.

that should be for 2.6.28.

> I'm hoping to polish up TJ's PCI allocation code
> (http://tjworld.net/wiki/Linux/PCIDynamicResourceAllocationManagement) for
> 2.6.28; it may have some stuff that can help.

not sure. actually we should rely on BIOS to allocate ioport/mmio for
us. and only do some minor adjust to BAR
that is obvious wrong. so have list for gap seems overkilling.
for Hotplug, the acpi code in dst should (pre)allocate the resource
for new insert devices.

YH
