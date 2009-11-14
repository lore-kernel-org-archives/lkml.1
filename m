Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZKNIso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZKNIso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 03:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZKNIsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 03:48:43 -0500
Received: from lucidpixels.com ([75.144.35.66]:36235 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZKNIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 03:48:42 -0500
Date: Sat, 14 Nov 2009 03:48:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <1258161139.21141.29.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan>  <1258069232.14894.9.camel@localhost.localdomain>  <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> 
 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>  <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>  <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>  <1258137165.21141.20.camel@localhost.localdomain> 
 <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan> <1258161139.21141.29.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:

> On Fri, 2009-11-13 at 10:43 -0800, Justin Piszcz wrote:
>>
>> On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
>>
>>> On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
>>>> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
>>>>> Yes. Yes. This is a hardware errata. I have a patch to workaround this and
>>>>> waiting on the errata description to get published..
>>>>
>>>> Can we at least have some PCI quirk or whatever until you can push the
>>>> final workaround out so peoples machines do not explode ?
>>>
>>> Its a harmless bug functionality-wise and should not have any side
>>> effect other than triggering the WARN_ON_ONCE in hpet next event code.
>>>
>>> Thanks,
>>> Venki
>>>
>>
>> Venki,
>>
>> When the following patch is applied though: (courtesy of john stultz)
>>
>
> Justin,
>
> I am missing something in here.
> Without the below patch, on 2.6.31.4 and ACPI_PROCESSOR loaded (either
> as module or builtin), you may see the WARNING. But, that should not
> cause any other problems with C-states, P-states, or anything else.
> Is that what you are seeing?
>
> The below patch is not a workaround for the problem. Infact it will make
> situation worse with constant stream of prinkts and can reduce the
> C-state residency and turbo upside.
>
> Thanks,
> Venki

Venki,

Without the below patch and ACPI_PROCESSOR loaded:

1. the warning? yes--however..
2. my processor does not enter turbo boost mode without the processor
    module
-
3. the patch shows that the hpet writes are failing-- when the processor
    module is loaded, the cpu/mobo/vrm emits a high-pitch noise-- my guess
    is due to the hpet write failures, failing over and over, this does
    not occur when the processor module is not loaded.

Justin.


