Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480Ab0AaVIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0AaVIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981Ab0AaVIw
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:08:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0AaVIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:08:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle of EC transaction
Date: Sun, 31 Jan 2010 22:09:21 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201001310029.48717.rjw@sisk.pl> <1264970500.5544.0.camel@maxim-laptop>
In-Reply-To: <1264970500.5544.0.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001312209.21212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 January 2010, Maxim Levitsky wrote:
> On Sun, 2010-01-31 at 00:29 +0100, Rafael J. Wysocki wrote: 
...
> >  
> >  static int acpi_ec_resume(struct acpi_device *device)
> >  {
> >  	struct acpi_ec *ec = acpi_driver_data(device);
> > +
> > +	mutex_lock(&ec->lock);
> >  	/* Enable use of GPE back */
> >  	acpi_enable_gpe(NULL, ec->gpe);
> > +	/* Allow transactions to happen again */
> > +	set_bit(EC_FLAGS_SUSPENDED, &ec->flags);
>           ^^^^^^^^^^^^
> Thats why it doesn't work here....
> Will retest now.

Ouch, sorry.

Rafael
