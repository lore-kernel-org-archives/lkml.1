Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYGVI0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYGVI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYGVI0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:26:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:45304 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYGVI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EMTiGpJaEs3AbOzXZ8zMNTN26uzhe5RUwS+UR2nvy6eTA6twhc3jI0kxTV0xntQ5/b
         H24SiPJ4WVKgD+mYZ97ipVCPZM1dKYIrTZeuG6zeXbNRS9vFhjRrSheOZDCWGiUgsMr1
         y8Yn7i0Re0aQzGNpno+uMG9FAraAXSte+P4nU=
Message-ID: <86802c440807220126l6caed5t3ad1bbe7da730669@mail.gmail.com>
Date: Tue, 22 Jul 2008 01:26:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Cc: "Paul Jackson" <pj@sgi.com>, "Mike Travis" <travis@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080722082410.GB2065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807211836.27282.yhlu.kernel@gmail.com>
	 <200807212208.22116.yhlu.kernel@gmail.com>
	 <20080722070734.GA16085@elte.hu> <20080722071324.GA2664@elte.hu>
	 <86802c440807220109s63307f28uc0658402cb26cfea@mail.gmail.com>
	 <20080722082410.GB2065@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 1:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Tue, Jul 22, 2008 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> > v2: fix compiling when CONFIG_ACPI is not set
>> >>
>> >> applied to tip/x86/x2apic - thanks Yinghai.
>> >>
>> >> > +static struct genapic *apic_probe[] __initdata = {
>> >> > +   &apic_x2apic_uv_x,
>> >> > +   &apic_x2apic_phys,
>> >> > +   &apic_x2apic_cluster,
>> >> > +   &apic_physflat,
>> >> > +   NULL,
>> >> > +};
>> >>
>> >> very nice generalization!
>> >
>> > btw.:
>> >
>> >   apic_probe[i]->acpi_madt_oem_check
>> >
>> > should probably be renamed to something more neutral like "->probe" -
>> > there's nothing ACPI about it and some weird boxes could use PCI or
>> > other probing mechanisms to discover the type of APIC they want to use.
>>
>> 32bit has acpi_madt_oem_check and mps_oem_check
>> 64bit should only have acpi_madt_oem_check
>
> yeah.
>
> It's just a small detail: what i mean is that the method itself should
> eventually simply be renamed from "acpi_madt_oem_check" to "probe".
> There's nothing ACPI about this exept the fact that most current "is
> this the APIC driver we should be using" checks involve some sort of
> ACPI discovery. This is a Linux abstraction and as such a more generic
> name like "probe" sounds more appropriate.

OK

YH
