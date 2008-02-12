Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYBLAPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYBLAPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYBLAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:14:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbYBLAOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:14:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Tue, 12 Feb 2008 01:13:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
References: <1202664109.8394.19.camel@mtlp> <200802120005.20601.rjw@sisk.pl> <1202773771.14135.1.camel@mtlp>
In-Reply-To: <1202773771.14135.1.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120113.07063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of February 2008, Mirco Tischler wrote:
> On Di, 2008-02-12 at 00:05 +0100, Rafael J. Wysocki wrote:
> > Well, this is strange, because one function introduced by this commit
> is
> > referred to by the subsequent commits.  Can you send me the patch
> reverting
> > this commit that you apply on top of 2.6.25-rc1, please?
> > 
> > Thanks,
> > Rafael
> 
> Here is the diff after reverting the patch.

OK, thanks.

Since _GTS and _BFS don't seem to be defined in your box's BIOS, please
try to apply the appended patch on top of the revert and see if that breaks
things again.

Thanks,
Rafael

---
 drivers/acpi/hardware/hwsleep.c |   11 -----------
 1 file changed, 11 deletions(-)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
@@ -199,11 +199,6 @@ acpi_status acpi_enter_sleep_state_prep(
 		return_ACPI_STATUS(status);
 	}
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		return_ACPI_STATUS(status);
-	}
-
 	/* Setup the argument to _SST */
 
 	switch (sleep_state) {
@@ -554,12 +549,6 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
 
-	arg.integer.value = sleep_state;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
-	}
-
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
 	 * might get fired there
