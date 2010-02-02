Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0BBBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:21:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:40563 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0BBBVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,386,1262592000"; 
   d="scan'208";a="769205592"
Subject: Re: ACPI device for ASUS EEEPC 1101HA not added
From: Zhang Rui <rui.zhang@intel.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>
In-Reply-To: <20100201032554.GZ28972@buzzloop.caiaq.de>
References: <20100201032554.GZ28972@buzzloop.caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 09:19:22 +0800
Message-ID: <1265073562.10648.12.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 11:25 +0800, Daniel Mack wrote:
> On my new 1101HA Eeepc, the special function keys do not work. This is
> because the asus-laptop driver fails to match the ACPI device named
> "ASUS010". However, acpidump tells me a device with that name does
> actually exist - the (simplified) disassembly of the DSDT is below.
> 
> It looks like the gigantic parser state machine fails to add that
> device for whatever reason. Any ideas how to fix that?
> 
eeepc is handled in eeepci-laptop driver.

~/src/linux-2.6$ grep ASUS010 drivers/platform/*/*
drivers/platform/x86/eeepc-laptop.c:#define EEEPC_ACPI_HID		"ASUS010"

thanks,
rui

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


