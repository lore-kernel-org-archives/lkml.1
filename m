Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYJXGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYJXGxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYJXGw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:52:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYJXGw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: Oops in ACPI with git latest
Date: Fri, 24 Oct 2008 08:47:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain> <200810232242.33480.rjw@sisk.pl> <1224811033.3330.54.camel@localhost.localdomain>
In-Reply-To: <1224811033.3330.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240847.49891.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, James Bottomley wrote:
> On Thu, 2008-10-23 at 22:42 +0200, Rafael J. Wysocki wrote:
> > On Thursday, 23 of October 2008, James Bottomley wrote:
> > > ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs 5, found 4 [20080926]
> > > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
> > > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return value [20080926]
> > > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > Does this patch help?
> > 
> > ---
> >  drivers/pci/pci-acpi.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6/drivers/pci/pci-acpi.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci-acpi.c
> > +++ linux-2.6/drivers/pci/pci-acpi.c
> > @@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
> >  	if (ACPI_FAILURE(status))
> >  		return status;
> >  
> > +	if (!output.pointer)
> > +		return AE_NULL_OBJECT;
> > +
> >  	out_obj = output.pointer;
> >  	if (out_obj->type != ACPI_TYPE_BUFFER) {
> >  		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
> 
> Yes, that seems to fix it, thanks! ... I suppose the ASL error and
> warnings need investigating too?

Unfortunately, they seem to indicate a BIOS breakage.

According to the spec, _OSC should take 4 arguments, but apparently on your
system it wants 5.

The output of acpidump may be helpful, as Lin Ming already said.

Thanks,
Rafael

