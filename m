Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYBLXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYBLXvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYBLXvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:51:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYBLXvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:51:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI suspend: Execute _WAK with the right argument
Date: Wed, 13 Feb 2008 00:49:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mirco Tischler <mt-ml@gmx.de>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200802130032.17636.rjw@sisk.pl> <20080212234513.GA2564@elf.ucw.cz>
In-Reply-To: <20080212234513.GA2564@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130049.15132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of February 2008, Pavel Machek wrote:
> On Wed 2008-02-13 00:32:16, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The _WAK global ACPI control method has to be called with the
> > argument representing the sleep state being exited.  Make it happen.
> > 
> > Special thanks to Mirco Tischler <mt-ml@gmx.de> for reporting the
> > problem and debugging.
> > 
> > Reported-by: Mirco Tischler <mt-ml@gmx.de>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACK. AFAICT this is 2.6.25 material.

Sure, it certainly is.  The bug has been breaking suspend on people's boxes
already.

Thanks,
Rafael


> > ---
> >  drivers/acpi/hardware/hwsleep.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
> > +++ linux-2.6/drivers/acpi/hardware/hwsleep.c
> > @@ -616,6 +616,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
> >  		return_ACPI_STATUS(status);
> >  	}
> >  
> > +	arg.integer.value = sleep_state;
> >  	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
> >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> >  		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
> 
