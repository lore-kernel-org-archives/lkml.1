Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYGRHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYGRHvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYGRHvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:51:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:48404 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYGRHvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HJmc00RqIO/FPPFt0VnE4A8lkiKHuov5tnK3ooCIgj2SBRxLxudoqubQfXtPuJV1UF
         RyHMUH0TCBmuwkbYuwlWKa0yOv1IwuIcxcdWqTAfqAjhNPOhXaawxa7TY0Yjx+N3JmyF
         lYVK9ObsxNL/TrL5uuUB20bzLNkZ5SIMqHqD4=
Message-ID: <19f34abd0807180051i544367b7s64f32d601af31296@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:51:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap trouble
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       "Huang Ying" <ying.huang@intel.com>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0807180117320.6536@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com>
	 <200807171245.31641.bjorn.helgaas@hp.com>
	 <19f34abd0807171358p3c5a44f9i91ab23d3f5e9671f@mail.gmail.com>
	 <Pine.LNX.4.55.0807180117320.6536@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:47 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>> Looks like APIC was misconfigured, which might explain IRQ routing weirdness?
>
>  Here pin1 and pin2 have been correctly initialised, but apic1 and apic2
> are both set to -1.  This is an "impossible scenario."  Because of that
> I/O APIC code actually pokes at random registers of the local APIC which
> immediately precedes I/O APIC #0 in the fixmap.  Results may be arbitrary.
>
>> Will try to provide the booting one later. Now zZz...
>
>  Your system uses an MP table and there were quite a lot of changes in its
> support code recently.  A bug must have crept in.  Please try the appended
> patch and the "apic=debug" option for both cases and the resulting logs
> may shed some light.

I have done this for the bad case:
http://folk.uio.no/vegardno/linux/netconsole2.txt

(I added a warning for certain APIC errors as well. Not that it adds
much in this particular case, but I think it would be good to have in
mainline anyway, to highlight these error cases in the future...)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
