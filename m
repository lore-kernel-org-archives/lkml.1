Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0CECJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:09:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61094 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0CECJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w/V84HOHHmWLsrNpygEaHdai2qfQTtZwm+QHub3B+SPu5y8gYrdL1JY1nAE8oybrvZ
         B0vMkh+1qcEm/5sJUyAWPslYcqX3yq4iOrwVhw9ZH69/wxkWOM8U0M6Yu9GnebfFK3Mw
         X8OpPoNRPJPJ0i7ZgCDDttSYdx9Js1hiEHkGU=
Message-ID: <4B9067C0.6050907@gmail.com>
Date: Thu, 04 Mar 2010 20:09:04 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: Andre Prendel <andre.prendel@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 2.6.33 on jetway nc81-lf board
References: <4B8C0598.2060000@xs4all.nl> <20100302213709.951ee97b.akpm@linux-foundation.org> <20100304091741.GA1995@andre-laptop> <4B8FC4F1.70605@xs4all.nl>
In-Reply-To: <4B8FC4F1.70605@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 08:34 AM, Udo van den Heuvel wrote:
> On 03/04/2010 10:17 AM, Andre Prendel wrote:
>> On Tue, Mar 02, 2010 at 09:37:09PM -0800, Andrew Morton wrote:
>>> (cc lm-sensors)
>>>
>>> On Mon, 01 Mar 2010 19:21:12 +0100 Udo van den Heuvel<udovdh@xs4all.nl>  wrote:
> (....)
>>>> No other sensor-related modules are loaded.
>>>>
>>>> What could be wrong?
>>
>> See lm-sensors FAQ Chapter3 #39:
>>
>>    http://www.lm-sensors.org/wiki/FAQ/Chapter3#Mysensorshavestoppedworkinginkernel2.6.31
>
> Thanks, but the explanation implies no real fix other than more
> consciously choosing to put system stability at risk.
> Is a better fix in the making?

I don't think a general fix is really possible at the kernel level. The 
problem is that there's no way for the kernel to tell for sure whether 
the BIOS AML or SMI code will attempt to access the sensor device. The 
fact that your BIOS defines AML operation regions that refer to the 
SMBus device is a hint that it may, but there's no programmatic way to 
tell for sure. If the kernel and BIOS end up attempting to poke the 
hardware monitoring chip at the same time, bad things are likely to 
happen (like ACPI thermal management not working properly causing 
overheating or critical shutdowns).

This problem isn't limited to Linux - loading software (at least that 
unapproved by the board manufacturer) on Windows that randomly pokes 
hardware sensors can cause similar problems if the BIOS attempts to 
access the same hardware.

The only real solution may be to check with the motherboard manufacturer 
to see if directly accessing the hardware sensors on that board is safe. 
(It's more likely to be OK on desktop machines than laptops, since they 
usually have less complex thermal/fan management, but there are no 
guarantees.)
