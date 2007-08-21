Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbXHUPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbXHUPP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXHUPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:15:14 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36906 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760706AbXHUPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:15:12 -0400
Message-ID: <46CB0169.7090207@suse.de>
Date: Tue, 21 Aug 2007 19:14:49 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] ACPI: Fix a warning of discarding qualifiers from
 pointer target type
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking>
In-Reply-To: <20070821150714.GA7591@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> Fix this warning:
>
> drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
> drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type
>
> (I don't know whether this fix hits the real problem.)
>   
It is safe to give acpi_get_devices() const string, as it should not
modify it in any condition.
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
>   
ACK

Thanks,
Alex
> ---
>  drivers/acpi/ec.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.23-rc3-git3/drivers/acpi/ec.c
> ===================================================================
> --- linux-2.6.23-rc3-git3.orig/drivers/acpi/ec.c
> +++ linux-2.6.23-rc3-git3/drivers/acpi/ec.c
> @@ -869,8 +869,8 @@ int __init acpi_ec_ecdt_probe(void)
>  		boot_ec->handle = ACPI_ROOT_OBJECT;
>  	} else {
>  		printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
> -		status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
> -						boot_ec, NULL);
> +		status = acpi_get_devices((char *)ec_device_ids[0].id,
> +						ec_parse_device, boot_ec, NULL);
>  		if (ACPI_FAILURE(status))
>  			goto error;
>  	}
>   

