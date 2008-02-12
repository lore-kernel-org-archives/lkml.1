Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYBLXY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYBLXY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYBLXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:24:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYBLXYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:24:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Wed, 13 Feb 2008 00:23:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
References: <1202664109.8394.19.camel@mtlp> <200802122318.46271.rjw@sisk.pl> <1202858441.7392.1.camel@mtlp>
In-Reply-To: <1202858441.7392.1.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130023.06167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of February 2008, Mirco Tischler wrote:
> 
> Am Dienstag, den 12.02.2008, 23:18 +0100 schrieb Rafael J. Wysocki:
> > Ouch.  I think I know what the problem is.
> > 
> > On top of this patch, please apply the appended one and retest.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/acpi/hardware/hwsleep.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
> > +++ linux-2.6/drivers/acpi/hardware/hwsleep.c
> > @@ -566,6 +566,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
> >  		return_ACPI_STATUS(status);
> >  	}
> >  
> > +	arg.integer.value = sleep_state;
> >  	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
> >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> >  		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
> Good news. That works perfectly.

Ah, ok.  Thanks for testing. :-)

Can you please check if the current mainline with the following patch applied
works on your box?

Thanks,
Rafael

---
 drivers/acpi/hardware/hwsleep.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
@@ -616,6 +616,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		return_ACPI_STATUS(status);
 	}
 
+	arg.integer.value = sleep_state;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
