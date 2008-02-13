Return-Path: <linux-kernel-owner+w=401wt.eu-S1765075AbYBMATc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765075AbYBMATc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764516AbYBMASs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:18:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764377AbYBMASq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:18:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Wed, 13 Feb 2008 01:16:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
References: <1202664109.8394.19.camel@mtlp> <200802130023.06167.rjw@sisk.pl> <1202861284.7548.2.camel@mtlp>
In-Reply-To: <1202861284.7548.2.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130116.52841.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of February 2008, Mirco Tischler wrote:
> 
> On Mi, 2008-02-13 at 00:23 +0100, Rafael J. Wysocki wrote:
> > Ah, ok.  Thanks for testing. :-)
> > 
> > Can you please check if the current mainline with the following patch applied
> > works on your box?
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
> > @@ -616,6 +616,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
> >  		return_ACPI_STATUS(status);
> >  	}
> >  
> > +	arg.integer.value = sleep_state;
> >  	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
> >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> >  		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
> Yes, works with current mainline too.
> 
> Much thanks for your help

Well, thanks for your patience. :-)

It's a well-hidden bug, so it probably would have taken much time to find it
without your ability to reproduce the problem.

Thanks,
Rafael
