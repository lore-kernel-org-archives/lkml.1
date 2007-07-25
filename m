Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXGYQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXGYQXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGYQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:23:47 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:36914 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXGYQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:23:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 10:11:35 -0600
User-Agent: KMail/1.9.6
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?iso-8859-1?q?S=E9bastien?= =?iso-8859-1?q?_Dugu=E9?=" 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707250655.07746.bjorn.helgaas@hp.com> <86802c440707250857u22e5afa3kefb06a997c38c3b8@mail.gmail.com>
In-Reply-To: <86802c440707250857u22e5afa3kefb06a997c38c3b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251011.35891.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 09:57:47 am Yinghai Lu wrote:
> On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Tuesday 24 July 2007 10:27:26 pm Yinghai Lu wrote:
> > > or we can make legacy_serial.force=1 is default at this point.
> >
> > At which point?  We already do the legacy probe if there are no
> > PNP devices.  Do you mean we should also do the legacy probe if
> > there are PNP devices, but no serial devices were found?  That
> > might be reasonable to do, but wouldn't have prevented the problem
> > on Sebastien's machine, because his machine *does* have PNP UARTs.
> 
> but still could have problem. if the system does not have any uart,
> and So we can not find that in DSDT...and we add legacy again...that
> is not right.

I'm sorry, I don't understand what you're saying.

The behavior with my patch is: If we have PNPBIOS or ACPI, and it
does not describe any UARTs, we assume the box has no UARTs.  If we
don't have PNPBIOS or ACPI, we blindly probe for legacy UARTs.

What behavior are you suggesting?

Bjorn
