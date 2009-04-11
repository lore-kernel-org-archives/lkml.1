Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZDKJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZDKJK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDKJKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:10:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZDKJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F8jevklKDaJAK6dxqzA/KP3BaSDbL2np/UsERCNEQrcKkLwz1NKbWweJ1R5lnkDDRQ
         YEQmzFx/1/Wm6wfwY2iLgOyRwhvV4vwCzyAU4hxaHb3dBVPbrEy3yubFxsJ51Ux84pTY
         XKcx5m/PxTmAAvKeIhWzjoB6frZiVNQjyLm5M=
Message-ID: <49E05F83.2090500@tuffmail.co.uk>
Date: Sat, 11 Apr 2009 10:14:43 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Regression: 20 ACPI interrupts per second on EEEPC 4G
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com>
In-Reply-To: <49DFE345.3010109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Alan Jenkins wrote:
>> On latest git, powertop shows 20 ACPI interrupts per second.  
>> Previously, this was closer to 1 per second.  See attached output (a 
>> vs b, "a" is from 2.6.29-rc8).
>>
>> This is from a pretty sparse KDE desktop.  Normally I run 
>> gnome-power-manager, but I killed it to make sure that wasn't causing 
>> any problems.
>>

>> gpe18:   60975  enabled
>> gpe_all:   60975
>> sci:   60975
>>
>> which I presume means lots of EC interrupts.
>>
>> [    0.134068] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data 
>> = 0x62
>>

> This patch looks to be a suspect: 
> 34ff4dbccccce54c83b1234d39b7ad9e548a75dd,
> Please check if reversing it helps

No, I still get 20 ACPI interrupts per second.

I tried without powertop, just in case that was provoking it, but it 
still happens:

alan@alan-eeepc:/sys/firmware/acpi/interrupts$ cat sci; sleep 5; cat sci
    2583
    2680

Thanks
Alan
