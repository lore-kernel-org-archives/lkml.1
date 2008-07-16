Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYGPR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYGPR3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYGPR3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:29:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:29922 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYGPR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pK8ZWhhYdIdoFnh0GU7ldL8YtMtuIMt9XlSvIPb353d3lA9fj3neLdFdQvP75W1nk+
         ZlLuWEzfzdQKjewSIpNKyC6wm/cxkCAYnap8dFAcH57vHD203nNi8jnxRbHrdsRTwxY/
         zmmB4HDNzRB6PHmExfkjEHKGCipTOxmF35GCQ=
Message-ID: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
Date: Wed, 16 Jul 2008 10:29:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Justin Mattock" <justinmattock@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716140810.GA2861@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:08 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Yunghai,
>   I had partial success with your proposed patch. The MacPro2
> identifier doesn't appear to be correct for a second generation
> MacBook Pro so I had to comment out the line...
>
>                     DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),
>
> With that change, a patched 2.6.26-git2 kernel now uses MMCONFIG.
> However I still see the same hang. The boot messages I see on
> screen are...
>
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> PCI: MCFG area at f0000000 reserved in E820
> PCI: Using MMCONFIG at f0000000 - f3ffffff
> PCI: Using configuration type 1 for base access
> ACPI: EC: EC description table is found, configuring boot EC
> ACPI: EC: non-query interrupt received, switching to interrupt mode

something wrong here

> ACPI: BIOS_OSI(Linux) query ignored via DMI
> ACPI: Interpreter enabled
> ACPI: (S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: drivers started in interrupt mode
> ACPI: PCI Root Bridge [PCI0] (0000.00)
> pci 0000:00:1f.00 : quirk region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000.00:1f:00 : quirk region 0500-053f claimed by ICH6 GPIO
>
> ...at which the boot hangs. On the positive side, I was able to fully
> boot if I passed 'pci=noacpi' to the kernel options (which never worked
> before with 2.6.26).
> I can post the dmesg from a noacpi boot of the
> patched kernel to my bugzilla report tonight if it would help debug the
> issues we are still seeing with ACPI.

that will help.

>   One thing I notice with the patched kernel (without noacpi) is that I
> only see buses 0 - 63. A normal boot of 2.6.25.10 on this machine (or
> 2.6.26 reportedly on a MacMini) always shows buses 0 - 255.

that is right

> Could this
> be related to the ACPI breakage? Let me know if I can do anything
> else to debug the ACPI issues under MMCONFIG.

please boot with
debug apic=verbose pci=routeirq

YH
