Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYBLXpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYBLXpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYBLXpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:45:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56077 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753158AbYBLXpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:45:01 -0500
Date: Wed, 13 Feb 2008 00:45:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mirco Tischler <mt-ml@gmx.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] ACPI suspend: Execute _WAK with the right argument
Message-ID: <20080212234513.GA2564@elf.ucw.cz>
References: <200802130032.17636.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802130032.17636.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-02-13 00:32:16, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The _WAK global ACPI control method has to be called with the
> argument representing the sleep state being exited.  Make it happen.
> 
> Special thanks to Mirco Tischler <mt-ml@gmx.de> for reporting the
> problem and debugging.
> 
> Reported-by: Mirco Tischler <mt-ml@gmx.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. AFAICT this is 2.6.25 material.
								Pavel

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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
