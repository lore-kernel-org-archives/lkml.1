Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYBLWGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYBLWGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbYBLWFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:05:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:59223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757117AbYBLWFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:05:48 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1+OMbJ0LCSOdchFbFst42rLJfI0d+IjJsS94BOglc
	nQKJw3wAdljBQ/
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
In-Reply-To: <200802120113.07063.rjw@sisk.pl>
References: <1202664109.8394.19.camel@mtlp> <200802120005.20601.rjw@sisk.pl>
	 <1202773771.14135.1.camel@mtlp>  <200802120113.07063.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 23:05:43 +0100
Message-Id: <1202853943.6790.3.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Dienstag, den 12.02.2008, 01:13 +0100 schrieb Rafael J. Wysocki:
> Since _GTS and _BFS don't seem to be defined in your box's BIOS, please
> try to apply the appended patch on top of the revert and see if that breaks
> things again.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/hardware/hwsleep.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
> +++ linux-2.6/drivers/acpi/hardware/hwsleep.c
> @@ -199,11 +199,6 @@ acpi_status acpi_enter_sleep_state_prep(
>  		return_ACPI_STATUS(status);
>  	}
>  
> -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> -	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> -		return_ACPI_STATUS(status);
> -	}
> -
>  	/* Setup the argument to _SST */
>  
>  	switch (sleep_state) {
> @@ -554,12 +549,6 @@ acpi_status acpi_leave_sleep_state(u8 sl
>  		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
>  	}
>  
> -	arg.integer.value = sleep_state;
> -	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
> -	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> -		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
> -	}
> -
>  	/*
>  	 * GPEs must be enabled before _WAK is called as GPEs
>  	 * might get fired there
Yes, that's it. This patch breaks things again.

Thanks
Mirco

