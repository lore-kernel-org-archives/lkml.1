Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYJXSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYJXSEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYJXSEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:04:31 -0400
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:50578 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754466AbYJXSEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:04:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=fuvgq+rybeeJ9zN984laD3mB2MWDNQyfilGuY/1tuCM0GZraEZ4WrEB8fWGZcRwx1PhnLQJL7naUOGQ6yrgN9RwauLcOq2z08yxGXVAUWECIbR/b45uoHqv/BbbYvHQd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: Oops in ACPI with git latest
Date: Fri, 24 Oct 2008 11:04:19 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <1224791103.3330.37.camel@localhost.localdomain> <200810240857.18190.rjw@sisk.pl> <4911F71203A09E4D9981D27F9D8308580AA7FA41@orsmsx503.amr.corp.intel.com>
In-Reply-To: <4911F71203A09E4D9981D27F9D8308580AA7FA41@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241104.19704.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So who wants to send me a final patch for this?

Thanks,
Jesse

On Friday, October 24, 2008 7:57 am Moore, Robert wrote:
> Since acpi_evaluate_object doesn't set the pointer value, it may be simply
> random.
>
> >-----Original Message-----
> >From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> >Sent: Thursday, October 23, 2008 11:57 PM
> >To: James Bottomley; Jesse Barnes
> >Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-kernel; Len Brown
> >Subject: Re: Oops in ACPI with git latest
> >
> >On Friday, 24 of October 2008, James Bottomley wrote:
> >> On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
> >> > +	if (!output.pointer)
> >> > +		return AE_NULL_OBJECT;
> >> > +
> >> >
> >> > This probably won't work. acpi_evaluate_object currently doesn't touch
> >
> >the pointer parameter if there is no return value, it only sets the length
> >to zero.
> >
> >> Actually, it does.
> >
> >Well, this was the only candidate for a NULL pointer dereference, so I'd
> > be surprised if it didn't. :-)
> >
> >> > So, you might try this:
> >> >
> >> > +	if (!output.length)
> >> > +		return AE_NULL_OBJECT;
> >> > +
> >
> >Still, I'd expect the AML interpreter to return error code in this case.
> >
> >> This also works.
> >
> >Why don't we make it extra safe, then. ;-)
> >
> >---
> >From: Rafael J. Wysocki <rjw@sisk.pl>
> >Subject: Prevent acpi_osc_run from using NULL objects
> >
> >Check if the object returned by acpi_evaluate_object() in
> >acpi_run_osc() is not NULL.
> >
> >Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >---
> > drivers/pci/pci-acpi.c |    3 +++
> > 1 file changed, 3 insertions(+)
> >
> >Index: linux-2.6/drivers/pci/pci-acpi.c
> >===================================================================
> >--- linux-2.6.orig/drivers/pci/pci-acpi.c
> >+++ linux-2.6/drivers/pci/pci-acpi.c
> >@@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
> > 	if (ACPI_FAILURE(status))
> > 		return status;
> >
> >+	if (!output.pointer || !output.length)
> >+		return AE_NULL_OBJECT;
> >+
> > 	out_obj = output.pointer;
> > 	if (out_obj->type != ACPI_TYPE_BUFFER) {
> > 		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jesse Barnes, Intel Open Source Technology Center

