Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbZJDV4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbZJDV4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZJDV4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:56:00 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40517 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbZJDVz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h6wCFGlvCLmcULg/e4o+GMqkNFsW8T8USMsSHHTEc8216nL6JNd+8CfVFbqzs0Fqq2
         zriwy7Kp5jqBaSVHPfU9N3hwge3zJ9RJn1xiFIM1TO/RVTMyQXPWLOsgEMDCJdFYKiTy
         iZ6O0i3o+kNsUVysAfD++5Vkb2DQRB0oNeDEg=
MIME-Version: 1.0
In-Reply-To: <4AC91578.2020807@suse.de>
References: <1254669853.26496.0.camel@carter>
	 <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com>
	 <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl>
	 <4AC91578.2020807@suse.de>
Date: Sun, 4 Oct 2009 23:55:21 +0200
Message-ID: <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 11:36 PM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Hi Rafael,
>
> This is not my rule, it was/is the rule of power device class. If you do not
> agree to it, please change
> appropriate documentation.

Oh, I did not know that. Thank you for pointing it out. I think you
are refering to:

 158Q: Suppose, my battery monitoring chip/firmware does not provides capacity
 159   in percents, but provides charge_{now,full,empty}. Should I calculate
 160   percentage capacity manually, inside the driver, and register CAPACITY
 161   attribute? The same question about time_to_empty/time_to_full.
 162A: Most likely, no. This class is designed to export properties which are
 163   directly measurable by the specific hardware available.
 164
 165   Inferring not available properties using some heuristics or mathematical
 166   model is not subject of work for a battery driver. Such functionality
 167   should be factored out, and in fact, apm_power, the driver to serve
 168   legacy APM API on top of power supply class, uses a simple heuristic of
 169   approximating remaining battery capacity based on its charge, current,
 170   voltage and so on. But full-fledged battery model is likely not subject
 171   for kernel at all, as it would require floating point calculation to deal
 172   with things like differential equations and Kalman filters. This is
 173   better be handled by batteryd/libbattery, yet to be written.

We are not calculating anything new just by the pleasure of doing it,
we are correcting a wrong value provided by the hardware.

Please correct me if I misunderstood you.

>
> Regards,
> Alex.
>
> Rafael J. Wysocki пишет:
>>
>> On Sunday 04 October 2009, Alexey Starikovskiy wrote:
>>>
>>> Hi Miguel,
>>
>> Hi Alex,
>>
>>> I am going to reject your patch on the basis, that the battery driver
>>> should report only
>>> information it gained from battery hardware, not interpret it in any way.
>>> As your patch fall into "interpret" category, it does not belong in the
>>> kernel and battery
>>> driver in particular. You may suggest it to any/all user space battery
>>> monitoring applications,
>>> this is the place for "interpretations".
>>
>> Well, we do quirks for PCI devices, suspend quirks etc. in the kernel, so
>> I'm
>> not really sure we should use the "no interpretation" as a general rule.
>>  IMO,
>> if there's a known broken system needing a quirk, it may just be more
>> reasonable to put the quirk into the kernel than to put it into every
>> single
>> user application out there.
>>
>> In this particular case we have an evidently quirky hardware (or BIOS) and
>> it's
>> not a fundamentally wrong idea to try to address that problem in the
>> kernel.
>>
>> Thanks,
>> Rafael
>
>
