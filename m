Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0BAP4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:56:13 -0500
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:36042 "EHLO
	postserver.uni-dortmund.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752371Ab0BAP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:56:09 -0500
References: <20100201032554.GZ28972@buzzloop.caiaq.de> <cone.1265022400.369355.2380.1000@eeekiste> <20100201125155.GB28972@buzzloop.caiaq.de>
Message-ID: <cone.1265039756.142340.4977.1000@eeekiste>
X-Mailer: http://www.courier-mta.org/cone/
From: andrej.gelenberg@udo.edu
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Acpi4asus-user] ACPI device for ASUS EEEPC 1101HA not added
Date: Mon, 01 Feb 2010 16:55:56 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there was a patch for 1005ha and 1000h (or so), but i can't find it
in the repository anymore. I miss it in 2.6.33-rc* too. 

acpi/blacklist: enable OSI(Linux) on newer eeepc
patch from git://git.iksaif.net/acpi4asus.git.

Regards,
Andrej

Daniel Mack writes:

> On Mon, Feb 01, 2010 at 12:06:40PM +0100, andrej.gelenberg@udo.edu wrote:
>> you need to whitelist your eee pc for OSI(Linux) in drivers/acpi/blacklist.c
>> like this:
>> 
>> +        /*
>> +        * On newer Eeepc, the interface used by eeepc-laptop (ASUS010)
>> +        * is disabled without _OSI(Linux)
>> +        */
>> +       {
>> +       .callback = dmi_enable_osi_linux,
>> +       .ident = "Asus Eeepc-1101HA",
>> +       .matches = {
>> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
>> +                    DMI_MATCH(DMI_PRODUCT_NAME, "1101HA"),
>> +               },
>> +       },
> 
> Great, thanks. That worked. Is that already queued anywhere or do you
> want me to send a proper patch?
> 
> Daniel
> 
> 
>> Daniel Mack writes:
>> 
>> >On my new 1101HA Eeepc, the special function keys do not work. This is
>> >because the asus-laptop driver fails to match the ACPI device named
>> >"ASUS010". However, acpidump tells me a device with that name does
>> >actually exist - the (simplified) disassembly of the DSDT is below.
>> >
>> >It looks like the gigantic parser state machine fails to add that
>> >device for whatever reason. Any ideas how to fix that?
>> >
>> >
>> >Thanks,
>> >Daniel
>> >
