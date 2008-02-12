Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYBLXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYBLXUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYBLXUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:20:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:46811 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751583AbYBLXUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:20:45 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX19Omjs9sQtOlruuUfCsJraAYn1bEKWoE0JYB4GmMR
	NgGYQPgqBbkj+Z
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
In-Reply-To: <200802122318.46271.rjw@sisk.pl>
References: <1202664109.8394.19.camel@mtlp> <200802120113.07063.rjw@sisk.pl>
	 <1202853943.6790.3.camel@mtlp>  <200802122318.46271.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 00:20:41 +0100
Message-Id: <1202858441.7392.1.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Dienstag, den 12.02.2008, 23:18 +0100 schrieb Rafael J. Wysocki:
> Ouch.  I think I know what the problem is.
> 
> On top of this patch, please apply the appended one and retest.
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
> @@ -566,6 +566,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
>  		return_ACPI_STATUS(status);
>  	}
>  
> +	arg.integer.value = sleep_state;
>  	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
>  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>  		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
Good news. That works perfectly.

Thanks
Mirco

