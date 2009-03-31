Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZCaUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZCaUho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZCaUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:37:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:45365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755408AbZCaUhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:37:33 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18Fyh9R8VEFdp/Y+LnysxMmthl5zHPgY8JkioD6G9
	1nz0Qc/dg0Xavx
Message-ID: <49D27F03.2070302@gmx.net>
Date: Tue, 31 Mar 2009 22:37:23 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: yakui_zhao <yakui.zhao@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "abelay@mit.edu" <abelay@mit.edu>, "rjw@sisk.pl" <rjw@sisk.pl>
Subject: Re: [PATCH] PNPACPI: Enable PNPACPI _PSx Support, v3
References: <49D101DA.50201@gmx.net> <1238463939.3625.99.camel@localhost.localdomain>
In-Reply-To: <1238463939.3625.99.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yakui_zhao wrote:

>     Very good patch.
>     Do you have the hardware on which the dedicated power source is
> required by the serial port(PnP device) in your hand?
> 

Yes, I have an IBM ThinkPad 600E. I need this patch in order to
be able receive accurate time using a DCF77 receiver attached
to the serial port.

[snip]

>> -	if (ACPI_FAILURE(status))
>> +	if (ACPI_FAILURE(acpi_set_current_resources(handle, &buffer)))
>>   		ret = -EINVAL;
>> +	else if (acpi_bus_power_manageable(handle))
>> +		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
> How about changing the power state before calling _SRS object?

I recall reading something in the ACPI spec that says that the power
needs to be set after the device was enabled.  But the main driver
for this order (_SRS followed by _PS0) is the symmetry to the required
_PS3 followed by _DIS (according to the spec).

[snip]

--- Witold
