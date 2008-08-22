Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYHVL3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYHVL3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYHVL3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:29:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:56120 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYHVL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bQ20102+2o4TBiFk0ThiuRtaei76WgRehhfJSNtueMxHV0ShhYdg1uiFUx+kWRfScP
         7gV0n0+FhBaIOih19R8EGFue0YkW4GTis/ffPkKPzo1AmwTQ2ecLSkIaX5XI2Sofq8X9
         e66T5OkVzJBMQfkJArVcOjcsCwS3mYdPYh/jI=
Message-ID: <74d0deb30808220429y73daf8cbg4b593516f05f7302@mail.gmail.com>
Date: Fri, 22 Aug 2008 13:29:34 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Cc: "Pavel Machek" <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       "Samuel Ortiz" <sameo@openedhand.com>
In-Reply-To: <f17812d70808220232o7976680fkbb34528c4b7b000f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
	 <20080822090318.GB6542@atrey.karlin.mff.cuni.cz>
	 <f17812d70808220232o7976680fkbb34528c4b7b000f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:32 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Fri, Aug 22, 2008 at 5:03 PM, Pavel Machek <pavel@suse.cz> wrote:
>>> Fundamental Design Flaw of the Device Driver Model?
>>> ===================================================
>>>
>>> Sorry for the misleading subject, its purpose is to draw your attention :-)
>>> The ideas below are preliminary and I hope I'm not making serious mistakes
>>> here.
>>>
>>> This question has actually been around in my mind for several months, when
>>> I started to work on some devices with multiple functions. Specifically, a
>>> Power Management IC (PMIC in short in the following text) usually includes
>>> LEDs support (charging, indication...) audio, touch screen, power monitoring,
>>> LDOs, DC-DC bucks, and possibly some others.
>>>
>>> The initial two ideas came into my mind were:
>>>
>>>    1. separate the functions into multiple devices, write a driver for each
>>>       of these devices
>>
>> Go for 1.
>>
>>>    4. An intermediate device with no bus, no driver, no many other things
>>>       is really not something deserving a "struct device", that's a waste
>>>       of memory.
>>
>> Memory is not _that_ expensive, and struct device is not that
>> big. Adding infrastructure to driver model for supporting this would
>> also cost you memory, this time in .text segment.
>>
>
> Actually I don't mind wasting additional memory for a better structure,
> but option (1) isn't. And I just assume you have read to the end of thi
>  mail, then you will see it's more like a concept change,no fundamental
> change to the code itself.
>
> Actually the reason to have two different kind of devices are obvious:
>
> 1. physical device - handles the bus related operations (read, write,
> locking, I/O)
> 2. virtual device - handles the functionality (interface with the
> upper framework)
>
> With this separation, the same IP on different semiconductor can be
> shared naturally. There are lot of such products esp in embedded market,
> with multiple shared IPs within a single die.
>
> Attached is a patch series to get you guys a feeling how the option
> (1) will look like, and think again about the device-driver relationship,
> the correctness of introducing an intermediate platform_device.

Instead of allocating/adding the platform subdevices manually in
da903x_add_subdevs, couldn't you use the MFD (multi function device)
infrastructure that seems to be intended for this case? Also, I think
that the da9030 base driver would then better fit in drivers/mfd, not
drivers/i2c/chips (didn't Jean Delvare himself state that ideally
drivers/i2c/chips should be empty?).

regards
Philipp
