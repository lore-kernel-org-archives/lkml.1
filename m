Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYBCT0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYBCT0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 14:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYBCT0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 14:26:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:58605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYBCT0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 14:26:41 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Juho <angelusx@gmail.com>
Subject: Re: Kernel 2.6.22.9 wanted dmidecode of my Acer Aspire 5102WLMi laptop, so here it is...
Date: Sun, 3 Feb 2008 14:26:24 -0500
User-Agent: KMail/1.9.5
References: <470E0BD3.3050803@gmail.com> <200801182326.31913.lenb@kernel.org> <479B0E8D.8030404@gmail.com>
In-Reply-To: <479B0E8D.8030404@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031426.25083.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008 05:42, you wrote:
> I booted to kernel 2.6.24 (patched with TuxOnIce 3.0 RC5) with parameter 
> acpi_osi=Linux.
> 
> System was pretty stable and nothing special errors happened while 
> surfing, reading mail & watching movies.
> But when I suspended: Kernel crashed when waking from suspend
> 
> When booted normally with acpi_osi=!Linux no problems at all, suspend 
> works etc.
> 
> Is this information enough? I would like to send more info when needed.
> 
> - Juho
> 
> Len Brown wrote:
> > On Thursday 11 October 2007 07:41, Juho wrote:
> >> System Information
> >>         Manufacturer: Acer
> >>         Product Name: Aspire 5100
> >>         Version: V3.05A
> >>         Serial Number: LXABH05039632066BD1601
> >>         UUID: 36323361-3930-3335-6237-0016D41742AF
> >>         Wake-up Type: Power Switch
> >>         SKU Number: Not Specified
> >>         Family: Not Specified
> >>
> >> Handle 0x0002, DMI type 2, 8 bytes
> >> Base Board Information
> >>         Manufacturer: Acer
> >>         Product Name: Navarro
> > 
> > Thanks for the dmidecode output.
> > 
> > Do you notice any functional difference when booting with
> > 
> > "acpi_osi=Linux"        (default for 2.6.22 and earlier)
> > vs.
> > "acpi_osi=!Linux"       (default for 2.6.23 and later)
> > 

Thanks for the acpidump and the testing.

                    If (\_OSI ("Windows 2006"))
                    {
                        Store (0x40, ^OSTB)
                        Store (0x40, ^TPOS)
                    }

                    If (\_OSI ("Linux"))
                    {
                        Store (0x01, LINX)
                        Store (0x80, ^OSTB)
                        Store (0x80, ^TPOS)
                    }

// LINX is a NOP
// OSTB is compard only to >= 4, so setting it to x80 has no effect
// OSTP() return value is never checked

However, TPOS is compared to 0x40 in several places, so
OSI(Linux) will cause changes there.
In particular OSI(Linux) will turn off some AML code
associated with ATA -- _STM and _PS0 code.
That may be the reason you see resume issues with acpi_osi=Linux.
(or frankly, it may be some other random problem)

But in any case, we've blacklisted all of Acer going forward.

thanks,
-Len


