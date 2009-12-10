Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZLJBAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZLJBAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZLJBAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:00:42 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:43746 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZLJBAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=C7sLMbsGt6kTgTKzL2WsVrSbhw6eLOmWf9m96po0OUAEPjENo8ojiL2LMRUBlPC9Uj
         IziM9HW+C3T9lhYxqWcpiws6BYzFHl1pZQh2f36bHQYx0ziv3Rx/Mk2SkJ4w7chUBpUQ
         41NXpRMAXb8/z3tI9MdAqZlh57Q8FvK85lQOg=
Message-ID: <4B20483C.6090309@gmail.com>
Date: Wed, 09 Dec 2009 19:00:44 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Useless thermal acpi driver ?
References: <20091209232608.25aed4ca@werewolf.home>
In-Reply-To: <20091209232608.25aed4ca@werewolf.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 04:26 PM, J.A. Magallón wrote:
> Hi all...
>
> I have a couple boxes where the thermal acpi driver gives this:
>
> bran:~>  sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:       +26.8°C  (crit = +100.0°C)
>
> bran:~>  acpi -t
> No support for device type: battery
>       Thermal 1: ok, 27.0 degrees C
>
> It stays _always_ the same, there is no difference if I run some number
> crunchin, or even if one of them is overclocked from 2.8 to 3.0 GHz.

There are systems where an ACPI thermal zone exists but isn't really 
hooked up to anything and just reports some dummy temperature value. My 
old system reported 40 degrees C no matter what. (I think it's something 
like the thermal zone support is part of the standard ACPI DSDT template 
the mobo maker got from the BIOS developer and they effectively disabled 
it by putting in the dummy temperature.)

> They are 1U supermicro boxes, ventilation is good, but I don't trust this
> measures...
> It looks like the system is using some kind of 'generic' acpi TZ driver,
> but as I'm used to good-ol' sensors modules, I don't know where to look.
>
> Previously I used the w83627hf module from sensors.

I'm assuming the kernel is preventing that module from loading since the 
ACPI DSDT has operation regions that refer to the device registers. 
There's no guarantee that this means the BIOS actually accesses the 
device, or if it does, that there's a way to get it to report what it 
sees other than to itself. If the BIOS doesn't actually access the 
device then you can use the acpi_enforce_resources=lax to allow it. The 
problem is this might be totally unsafe and the kernel has no way to 
tell if it is or isn't.
