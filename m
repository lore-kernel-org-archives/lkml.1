Return-Path: <linux-kernel-owner+w=401wt.eu-S1161428AbXBHCiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161428AbXBHCiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161472AbXBHCiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:38:51 -0500
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:28948 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161428AbXBHCiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:38:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MyEXmWlWkkNyny+4qdm5+s5beGS6cZ2Ekzl5vc5s+XuMNy+NPhTJB2LXs6/c6ahQRif5olzOPwuj1fQUHdLFddvvmjXGuPsJguMrJHiG/mYkogDOBmEflE/kIVV4pqlOMR7vzjWfpzqH/on0/TMJXLNqFtH5JRC7oOpJqzCLj8M=  ;
X-YMail-OSG: DvBUZqEVM1nzxWCoE4_vK1hDLN3VeSMKLGMP4iHKaaWItAah2vdvK8tVBgCcypg_5te6FYtOsaK3eDCH1MOasDxPsXBnUzK6lFEQ_AbUoTIP0QWccdpKJ7t7HHMsSS4BFJV31hz5_GEnpiI-
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Atmel SPI controller driver
Date: Wed, 7 Feb 2007 13:30:15 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Russell King <rmk@arm.linux.org.uk>
References: <20070207171540.779c5a0b@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070207171540.779c5a0b@dhcp-252-105.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071330.16003.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 8:15 am, Haavard Skinnemoen wrote:
> Driver for the Atmel on-chip SPI master controller.
> 
> Tested primarily on AVR32/AT32AP7000/ATSTK1000 using mtd_dataflash and
> the jffs2 filesystem.

Call me paranoid, but until such controller drivers can withstand
loads placed by filesystems I have a hard time trusting them!  ;)

Various drivers using smaller transfers (control for LCD or audio DAC,
sensors, EEPROM access) have also been reported to work.


> Should also work fine on various AT91 ARM-based 
> chips like AT91SAM926x.

And answering a question we had:  I did get confirmation from one person,
saying that they'd used a previous version of this driver on at91rm9200
with success.

I think that answers Andrew Victor's basic question about whether the
"legacy" at91 SPI driver is ready to go away ... the main unresolved
issue being a replacement for that old userspace interface.  (And that
issue is nearly resolved too.)


> Hardware documentation can be found in the AT32AP7000 data sheet,
> which can be downloaded from
> 
> http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> Note that this driver depends on the arch-neutral GPIO API patches
> currently in -mm.

So this should follow the merge of the AVR32 architecture updates, and
the AT91 GPIO patch, to prevent creation of configs that won't build.

ISTR that AT91 also needs some arch updates to make it _run_ properly
(to use the same board init conventions), but IMO this can merge before
those if that simplifies the process.  (That is, no need to wait for
AT91 patches to go from Andrew to Russell to Linus first.)

Thanks for making this driver happen!

- Dave

 
