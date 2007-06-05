Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbXFEAtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbXFEAtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbXFEAtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:49:16 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:34425 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbXFEAtP (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:49:15 -0400
Date: Mon, 04 Jun 2007 18:49:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang
 on reboot
In-reply-to: <fa./cH7AY3hv2QMikoTK1P7fAVvbdI@ifi.uio.no>
To: James Jarvis <James.Jarvis@ed.ac.uk>
Cc: Riley@Williams.Name, Linux-Kernel@vger.kernel.org, graham.newton@ed.ac.uk,
       kenneth.macdonald@ed.ac.uk
Message-id: <4664B306.5000107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./cH7AY3hv2QMikoTK1P7fAVvbdI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Jarvis wrote:
> I trust this is the right list...
> 
> The following patch enables reboot through BIOS on the Dell Optiplex 745 
> Small Form Factor base, on which reboot hangs. The larger form factor 
> does not require this, hence the match on DMI_BOARD_NAME.
> 
> --- arch/i386/kernel/reboot.c.orig      2007-06-01 12:22:53.000000000 +0100
> +++ arch/i386/kernel/reboot.c   2007-06-04 16:53:36.000000000 +0100
> @@ -104,6 +104,15 @@
>                        DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
>                },
>        },
> +       {       /* Handle problems with rebooting on Dell Optiplex 745's 
> SFF*/
> +               .callback = set_bios_reboot,
> +               .ident = "Dell OptiPlex 745",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
> +                       DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
> +               },
> +       },
>        {       /* Handle problems with rebooting on Dell 2400's */
>                .callback = set_bios_reboot,
>                .ident = "Dell PowerEdge 2400",

This blacklist seems to be growing. Isn't there something better we can 
do here? Can we just reboot through the BIOS by default, is that really 
broken on some systems?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

