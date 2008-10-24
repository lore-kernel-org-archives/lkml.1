Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYJXSiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYJXSiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYJXSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:38:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYJXSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:38:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Oops in ACPI with git latest
Date: Fri, 24 Oct 2008 20:43:03 +0200
User-Agent: KMail/1.9.9
Cc: "Moore, Robert" <robert.moore@intel.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <1224791103.3330.37.camel@localhost.localdomain> <4911F71203A09E4D9981D27F9D8308580AA7FA41@orsmsx503.amr.corp.intel.com> <200810241104.19704.jbarnes@virtuousgeek.org>
In-Reply-To: <200810241104.19704.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242043.04078.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, Jesse Barnes wrote:
> So who wants to send me a final patch for this?

I already did: http://marc.info/?l=linux-kernel&m=122484871717023&w=4
but I can remove the "!output.pointer || " if you prefer. :-)

Thanks,
Rafael


> On Friday, October 24, 2008 7:57 am Moore, Robert wrote:
> > Since acpi_evaluate_object doesn't set the pointer value, it may be simply
> > random.
> >
> > >-----Original Message-----
> > >From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > >Sent: Thursday, October 23, 2008 11:57 PM
> > >To: James Bottomley; Jesse Barnes
> > >Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-kernel; Len Brown
> > >Subject: Re: Oops in ACPI with git latest
> > >
> > >On Friday, 24 of October 2008, James Bottomley wrote:
> > >> On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
> > >> > +	if (!output.pointer)
> > >> > +		return AE_NULL_OBJECT;
> > >> > +
> > >> >
> > >> > This probably won't work. acpi_evaluate_object currently doesn't touch
> > >
> > >the pointer parameter if there is no return value, it only sets the length
> > >to zero.
> > >
> > >> Actually, it does.
> > >
> > >Well, this was the only candidate for a NULL pointer dereference, so I'd
> > > be surprised if it didn't. :-)
> > >
> > >> > So, you might try this:
> > >> >
> > >> > +	if (!output.length)
> > >> > +		return AE_NULL_OBJECT;
> > >> > +
> > >
> > >Still, I'd expect the AML interpreter to return error code in this case.
> > >
> > >> This also works.
> > >
> > >Why don't we make it extra safe, then. ;-)
> > >
> > >---
> > >From: Rafael J. Wysocki <rjw@sisk.pl>
> > >Subject: Prevent acpi_osc_run from using NULL objects
> > >
> > >Check if the object returned by acpi_evaluate_object() in
> > >acpi_run_osc() is not NULL.
> > >
> > >Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > >---
> > > drivers/pci/pci-acpi.c |    3 +++
> > > 1 file changed, 3 insertions(+)
> > >
> > >Index: linux-2.6/drivers/pci/pci-acpi.c
> > >===================================================================
> > >--- linux-2.6.orig/drivers/pci/pci-acpi.c
> > >+++ linux-2.6/drivers/pci/pci-acpi.c
> > >@@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
> > > 	if (ACPI_FAILURE(status))
> > > 		return status;
> > >
> > >+	if (!output.pointer || !output.length)
> > >+		return AE_NULL_OBJECT;
> > >+
> > > 	out_obj = output.pointer;
> > > 	if (out_obj->type != ACPI_TYPE_BUFFER) {
> > > 		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 


