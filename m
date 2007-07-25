Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbXGYE1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbXGYE1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXGYE12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:27:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:44390 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXGYE11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=snJklpxUkcIiQAaDt4iN4FrTpwz5lqj6MfdIiqwADjjBHqloHgb77smMaZOYv2veOFaoTEC/pJnCMtnU+Kw/9IeYiES3vnLrNRXCClr7KyAMgvvZ+WaHELmm1zpcjasDhx2Xa2luhwHDXOu7yRK2gpHwfQeAXSmEVlw4h+MDiTA=
Message-ID: <86802c440707242127n17a27a29u6d821044bfba8cf9@mail.gmail.com>
Date: Tue, 24 Jul 2007 21:27:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200707242034.42679.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <46A65D7D.6040409@garzik.org>
	 <86802c440707241333qcaac27fw8a265098cd164be8@mail.gmail.com>
	 <200707242034.42679.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Tuesday 24 July 2007 02:33:05 pm Yinghai Lu wrote:
> > I have a system that has the same problem, and it turns out that FW
> > missed PNP0501 is DSDT for uart. and add that it into DSDT works well.
>
> Is this FW that has been shipped?  Can you give any more details,
> like DMI info and a copy of the DSDT?  We can't expect users to
> upgrade their firmware or use a custom DSDT.

The system is not shipped yet.
Normally PNP0501 is coming with superio section in DSDT. So i think
late BIOS if have acpi there, that should be there already.
Problem is that some new design may get rid of superio, but SB could
have extra uart for serial port. at that case BIOS may not have that
PNP0501...

I don't think revert is reasonable.

or we can make legacy_serial.force=1 is default at this point.

YH
