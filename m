Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYBMAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYBMAK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYBMAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:10:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:40291 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752156AbYBMAKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:10:17 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1+GBgV9so2GypWu11hVrYKgcXuMeNMfo+nIKW3ouJ
	3NhiqaYG675EPo
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
In-Reply-To: <200802130023.06167.rjw@sisk.pl>
References: <1202664109.8394.19.camel@mtlp> <200802122318.46271.rjw@sisk.pl>
	 <1202858441.7392.1.camel@mtlp>  <200802130023.06167.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 01:08:04 +0100
Message-Id: <1202861284.7548.2.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mi, 2008-02-13 at 00:23 +0100, Rafael J. Wysocki wrote:
> Ah, ok.  Thanks for testing. :-)
> 
> Can you please check if the current mainline with the following patch applied
> works on your box?
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/hardware/hwsleep.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
> +++ linux-2.6/drivers/acpi/hardware/hwsleep.c
> @@ -616,6 +616,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
>  		return_ACPI_STATUS(status);
>  	}
>  
> +	arg.integer.value = sleep_state;
>  	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
>  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>  		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
Yes, works with current mainline too.

Much thanks for your help
Mirco

