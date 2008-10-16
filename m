Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYJPJMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYJPJMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYJPJM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:12:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33742 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYJPJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:12:28 -0400
Date: Thu, 16 Oct 2008 11:12:26 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Message-ID: <20081016091226.GB15439@atrey.karlin.mff.cuni.cz>
References: <200810142254.07024.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810142254.07024.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
> 
> HP xw4600 Workstation is known to require the "old" (ie. compatible
> with ACPI 1.0) suspend code ordering, so blacklist it for this
> purpose.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Tested-by: John Brown <john.brown3@hp.com>

ACK.

> ---
>  drivers/acpi/sleep/main.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/sleep/main.c
> +++ linux-2.6/drivers/acpi/sleep/main.c
> @@ -298,6 +298,14 @@ static struct dmi_system_id __initdata a
>  		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
>  		},
>  	},
> +	{
> +	.callback = init_old_suspend_ordering,
> +	.ident = "HP xw4600 Workstation",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
> +		},
> +	},
>  	{},
>  };
>  #endif /* CONFIG_SUSPEND */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
