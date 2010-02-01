Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0BALWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:22:32 -0500
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:54504 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BALWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:22:31 -0500
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 06:22:30 EST
References: <20100201032554.GZ28972@buzzloop.caiaq.de>
Message-ID: <cone.1265022400.369355.2380.1000@eeekiste>
X-Mailer: http://www.courier-mta.org/cone/
From: andrej.gelenberg@udo.edu
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Acpi4asus-user] ACPI device for ASUS EEEPC 1101HA not added
Date: Mon, 01 Feb 2010 12:06:40 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

you need to whitelist your eee pc for OSI(Linux) in drivers/acpi/blacklist.c
like this:

+        /*
+        * On newer Eeepc, the interface used by eeepc-laptop (ASUS010)
+        * is disabled without _OSI(Linux)
+        */
+       {
+       .callback = dmi_enable_osi_linux,
+       .ident = "Asus Eeepc-1101HA",
+       .matches = {
+                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+                    DMI_MATCH(DMI_PRODUCT_NAME, "1101HA"),
+               },
+       },

Regards,
Andrej

Daniel Mack writes:

> On my new 1101HA Eeepc, the special function keys do not work. This is
> because the asus-laptop driver fails to match the ACPI device named
> "ASUS010". However, acpidump tells me a device with that name does
> actually exist - the (simplified) disassembly of the DSDT is below.
> 
> It looks like the gigantic parser state machine fails to add that
> device for whatever reason. Any ideas how to fix that?
> 
> 
> Thanks,
> Daniel
> 
> 
> /*
>  * Intel ACPI Component Architecture
>  * AML Disassembler version 20090521
>  */
> DefinitionBlock ("out/DSDT-0x3f660430-0.aml", "DSDT", 2, "A1359", "A1359000", 0x00000000)
> {
> 
>     [...]
> 
>     Scope (_SB)
>     {
> 
>         [...]
> 
>         Device (PCI0)
>         {
>             Name (_HID, EisaId ("PNP0A08"))
>             Name (_ADR, Zero)
> 
>             [...]
> 
>             Device (SBRG)
>             {
> 
>                 [...]
> 
>                 Scope (\_SB)
>                 {
>                     Name (ATKP, Zero)
>                     Device (ATKD)
>                     {
>                         Name (_HID, "ASUS010")
>                         Name (_UID, 0x01010100)
> 
>                         [...]
> 
> 
> The full version of the dump is here:
> 
>   http://caiaq.de/download/tmp/DSDT-0x3f660430-0.dsl
> 
> 
> ------------------------------------------------------------------------------
> The Planet: dedicated and managed hosting, cloud storage, colocation
> Stay online with enterprise data centers and the best network in the business
> Choose flexible plans and management services without long-term contracts
> Personal 24x7 support from experience hosting pros just a phone call away.
> http://p.sf.net/sfu/theplanet-com
> _______________________________________________
> Acpi4asus-user mailing list
> Acpi4asus-user@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/acpi4asus-user
