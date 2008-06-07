Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYFGK7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYFGK7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYFGK7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:59:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:65108 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYFGK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ajShY6rTxJTXk8lWMsyv2nEJB9x4cDDbshqgilswHjSFiT1XXb0QGNpNYg6AAvuk38
         8NGcM+23UrJ2O8Q6vBuXLxEnTdY482oW4lj9Be8UyqfJgpTFVhxBAC9R5KYY5o2Ht2QT
         nGfUyoVB8ErOJsh/sFQqNUUe2/1/tnULCHp+w=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
Date: Sat, 7 Jun 2008 13:59:04 +0300
User-Agent: KMail/1.9.9
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com> <20080606235526.783acc83.akpm@linux-foundation.org>
In-Reply-To: <20080606235526.783acc83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806071359.04426.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 June 2008 09:55:26 Andrew Morton wrote:
> On Sat, 7 Jun 2008 06:21:54 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
> 
> > Well; I was hoping it was going to be just an easy fix, but unfortunately
> > changing
> >  if (atomic_read(&ec->irq_count) > 5) {
> >  to
> > if (atomic_read(&ec->irq_count) > 20) {
> > does seem to make the message disappear, for a while, probably at
> > around three hours,(for me at least) then the message appeared again.
> > :-(
> > So leaving me back to the beginning of try to have a go at this.
> > regards;
> 
> I removed bugzilla from cc - that only works if there's [Bug 1234] in
> the Subject:.
> 
> I added linux-acpi to cc - this is an acpi problem.
> 
> What Justin is mysteriously referring to here is:
> 
> 
> : From: "Justin Mattock" <justinmattock@gmail.com>
> : To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
> : Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> : Subject: GPE storm detected, disabling EC GPE
> : Date: 	Thu, 5 Jun 2008 21:01:55 +0000
> : Sender: linux-kernel-owner@vger.kernel.org
> : 
> : FWIW I noticed a post where the person had changed 5 to 20, and it
> : seemed to work for them;
> : So with that in mind I decide to give that a go, here is the location:
> : drivers/acpi/ec.c
> : @@ -527,47 +488,51 @@ static u32 acpi_ec_gpe_handler(void *data)
> :  {
> :         acpi_status status = AE_OK;
> :         struct acpi_ec *ec = data;
> :        u8 state = acpi_ec_read_status(ec);
> : 
> :         pr_debug(PREFIX "~~~> interrupt\n");
> :        atomic_inc(&ec->irq_count);
> : -       if (atomic_read(&ec->irq_count) > 5) {
> : +       if (atomic_read(&ec->irq_count) > 20) {
> :                pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
> :                ec_switch_to_poll_mode(ec);
> :                goto end;
> :        }
> : 
> : Now I don't know if this will work for other brands, but for
> : me(Macbook Pro ATI chipset) I have not received the
> : GPE storm detected, disabling EC GPE message, but it's only been an
> : hour, maybe after two or three this might appear.
> : Also is this good or bad to set 5 to 20 for the system?
> 
> Could someone from acpi land please help here?
> 
> Justin, has this machine always had this problem or is it something
> which earlier kernels handled correctly?
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

I have acer aspire 5720G which shows this message in latest -git
but doesn't show it in ubuntu 2.6.24 kernel.

I also noticed that in -git volume wheel behaves strangely, it sometimes increases volume
when I rotate it in direction of decrease, and vise versa.

Since the EC is in charge of volume wheel, it could be related.

Best regards,
	Maxim Levitsky
