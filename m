Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYKKWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYKKWUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYKKWT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:19:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbYKKWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:19:58 -0500
Date: Tue, 11 Nov 2008 14:19:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hp-wmi: Fix warnings
Message-Id: <20081111141949.38c840d2.akpm@linux-foundation.org>
In-Reply-To: <490DD6F6.8000708@lwfinger.net>
References: <490DD6F6.8000708@lwfinger.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 08:36:06 -0800
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Subject: [PATCH] hp-wmi: Fix warnings

A nit: the point of such a patch is _not_ to "fix warnings".  It is to
fix the issues which those warnings are warning us about!

I renamed the patch to "hp-wmi: handle rfkill_register() failure",
thanks.

> Compilation of the HP WMI hotkeys code results in the following:
> 
>   CC [M]  drivers/misc/hp-wmi.o
> drivers/misc/hp-wmi.c: In function hp_wmi_bios_setup:
> drivers/misc/hp-wmi.c:431: warning: ignoring return value of rfkill_register,
> 	 declared with attribute warn_unused_result
> drivers/misc/hp-wmi.c:441: warning: ignoring return value of rfkill_register,
> 	 declared with attribute warn_unused_result
> drivers/misc/hp-wmi.c:450: warning: ignoring return value of rfkill_register,
> 	 declared with attribute warn_unused_result
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> 
> Index: linux-2.6/drivers/misc/hp-wmi.c
> ===================================================================
> --- linux-2.6.orig/drivers/misc/hp-wmi.c
> +++ linux-2.6/drivers/misc/hp-wmi.c
> @@ -428,7 +428,9 @@ static int __init hp_wmi_bios_setup(stru
>  		wifi_rfkill->state = hp_wmi_wifi_state();
>  		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
>  		wifi_rfkill->user_claim_unsupported = 1;
> -		rfkill_register(wifi_rfkill);
> +		err = rfkill_register(wifi_rfkill);
> +		if (err)
> +			goto add_sysfs_error;
