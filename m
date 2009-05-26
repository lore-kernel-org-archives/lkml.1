Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZEZUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZEZUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbZEZUAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:00:23 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:27033 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbZEZUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:00:22 -0400
Date: Tue, 26 May 2009 16:00:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 -tip] drm/i915: acpi/video.c fix section mismatch
 warning
In-reply-to: <1242800768.3260.21.camel@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0905261559500.18024@localhost.localdomain>
References: <1242800768.3260.21.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi tree.

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 20 May 2009, Jaswinder Singh Rajput wrote:

> 
> Currently acpi_video_exit() is exported as well as using __exit which causes:
> 
>   WARNING: drivers/acpi/video.o(__ksymtab+0x0): Section mismatch in reference from the variable __ksymtab_acpi_video_exit to the function .exit.text:acpi_video_exit()
>   The symbol acpi_video_exit is exported and annotated __exit
>   Fix this by removing the __exit annotation of acpi_video_exit or drop the export.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/acpi/video.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 810cca9..a79b885 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -2334,7 +2334,7 @@ static int __init acpi_video_init(void)
>  	return acpi_video_register();
>  }
>  
> -void __exit acpi_video_exit(void)
> +void acpi_video_exit(void)
>  {
>  
>  	acpi_bus_unregister_driver(&acpi_video_bus);
> -- 
> 1.6.1.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
