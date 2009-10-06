Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZJFPAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZJFPAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZJFPAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:00:49 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39655 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZJFPAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kle0se1J3XN+4vxo2SPAKjarDO/t8E5vJCqeVJiG1iS6Xa4jZr45wgOXxbT3EYPKxT
         VfsLx0WA0PZ0Td6td24WU3rJ9s+zypENNbt5nqWndVP2gQqzRrZ9amuW6p2VRzWx8P+L
         oldr38mzZEJx5JKhPKVUizdXbf9f2XfA6eJ6g=
MIME-Version: 1.0
In-Reply-To: <4ACA21E8.6080501@msgid.tls.msk.ru>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <4AC939BB.8090600@wasp.net.au>
	 <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
	 <4ACA21E8.6080501@msgid.tls.msk.ru>
Date: Tue, 6 Oct 2009 17:00:11 +0200
Message-ID: <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Brad Campbell <brad@wasp.net.au>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 6:42 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Luca Tettamanti wrote:
> []
>>>
>>> Vanilla Kernel 2.6.31.1 fails to load it87 on my machine with the same
>>> messages as posted above.
>
> []
>>>
>>> In addition, asus_atk0110 loads but leaves no trace in dmesg when loaded.
>>
>> That's good ;-) The driver is quiet when everything is ok. You should
>> see the corresponding entries under /sys/class/hwmon/hwmonN; upgrade
>> lm-sensor package to version 3.1.1, older versions do not support ACPI
>> devices.
>>
>>> Motherboard is an Asus M2N32-WS. DSDT attached.
>>
>> From a quick glance it should work. If it doesn't enable
>> CONFIG_HWMON_DEBUG_CHIP.
>
> Well, I just tried it here and it works here too, on 3 different
> asus motherboards.  But asus_atk0110 is far less useful than the
> it87 variant.  Yes atk0110 shows correct labels for various sensors,
> but for one there's no way to control fan speeds using it, at least
> not currently, -- something which is done by it87 easily.
>
> Well, one more difference is that atk0110 also shows vcore, which
> at least looks real instead of fake 1.55V as shown by it87.
>
> But anyway, loading the driver just to get correct labels and
> vcore seems a bit overkill...

The main reason for using atk0110 is correctness: the resources are
claimed by ACPI, it might not be safe to touch them (for the same
reason two drivers are not allowed to map e.g. the same PCI BAR).
On newer boards the risk of collision is pretty high, since the hwmon
chip is used by an EC that works in background... on other boards the
risk is much lower since the hwmon chip doesn't seem to be probed
actively.
Anyway, as user you can override this decision with
"acpi_enforce_resources=lax", but _I_ wouldn't recommend it.

Luca
