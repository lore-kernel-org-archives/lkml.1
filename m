Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYJFFf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYJFFf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYJFFfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:35:12 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:56485 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFFfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:35:10 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 01:35:10 EDT
Date: Mon, 06 Oct 2008 00:34:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI Suspend: Enable ACPI during resume if SCI_EN is not
 set
In-reply-to: <200810040005.06220.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Message-id: <alpine.LFD.1.10.0810060034050.2973@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200810040005.06220.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test.

thanks,
-Len

On Sat, 4 Oct 2008, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
> 
> On some machines, like for example MSI Wind U100, the BIOS doesn't
> enable ACPI before returning control to the OS, which sometimes
> causes resume to fail.  This is against the ACPI specification,
> which clearly states that "When the platform is waking from an S1, S2
> or S3 state, OSPM assumes the hardware is already in the ACPI mode
> and will not issue an ACPI_ENABLE", but it won't hurt to check the
> SCI_EN bit and enable ACPI during resume from S3 if this bit is not
> set.
> 
> Fortunately, we already have acpi_enable() for that, so use it in the
> resume code path, before executing _BFS, in analogy with the
> resume-from-hibernation code path.
> 
> NOTE: We aren't supposed to set SCI_EN directly, because it's owned
> by the hardware.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/acpi/sleep/main.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/sleep/main.c
> +++ linux-2.6/drivers/acpi/sleep/main.c
> @@ -200,6 +200,8 @@ static int acpi_suspend_enter(suspend_st
>  		break;
>  	}
>  
> +	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
> +	acpi_enable();
>  	/* Reprogram control registers and execute _BFS */
>  	acpi_leave_sleep_state_prep(acpi_state);
>  
> 
