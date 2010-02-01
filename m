Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0BAMwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:52:02 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:48662 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0BAMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:52:00 -0500
Date: Mon, 1 Feb 2010 13:51:55 +0100
From: Daniel Mack <daniel@caiaq.de>
To: andrej.gelenberg@udo.edu
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Acpi4asus-user] ACPI device for ASUS EEEPC 1101HA not added
Message-ID: <20100201125155.GB28972@buzzloop.caiaq.de>
References: <20100201032554.GZ28972@buzzloop.caiaq.de>
 <cone.1265022400.369355.2380.1000@eeekiste>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1265022400.369355.2380.1000@eeekiste>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 12:06:40PM +0100, andrej.gelenberg@udo.edu wrote:
> you need to whitelist your eee pc for OSI(Linux) in drivers/acpi/blacklist.c
> like this:
> 
> +        /*
> +        * On newer Eeepc, the interface used by eeepc-laptop (ASUS010)
> +        * is disabled without _OSI(Linux)
> +        */
> +       {
> +       .callback = dmi_enable_osi_linux,
> +       .ident = "Asus Eeepc-1101HA",
> +       .matches = {
> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
> +                    DMI_MATCH(DMI_PRODUCT_NAME, "1101HA"),
> +               },
> +       },

Great, thanks. That worked. Is that already queued anywhere or do you
want me to send a proper patch?

Daniel


> Daniel Mack writes:
> 
> >On my new 1101HA Eeepc, the special function keys do not work. This is
> >because the asus-laptop driver fails to match the ACPI device named
> >"ASUS010". However, acpidump tells me a device with that name does
> >actually exist - the (simplified) disassembly of the DSDT is below.
> >
> >It looks like the gigantic parser state machine fails to add that
> >device for whatever reason. Any ideas how to fix that?
> >
> >
> >Thanks,
> >Daniel
> >
