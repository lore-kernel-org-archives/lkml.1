Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZBFTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZBFTxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZBFTxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:53:05 -0500
Received: from mail.candelatech.com ([208.74.158.172]:50594 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZBFTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:53:04 -0500
X-Greylist: delayed 1971 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 14:53:03 EST
Message-ID: <498C951A.3070101@candelatech.com>
Date: Fri, 06 Feb 2009 11:52:58 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Regression on VIA C3 motherboard, commit: 66f2173e2
References: <498A93E5.2080509@candelatech.com> <alpine.LFD.2.00.0902061350470.26256@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902061350470.26256@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> Thanks for the bisect, Ben.
> 
> Please test the patch below.

With this patch, performance is fine, and I do not see
my smp hack being exercised.  I still have ACPI off
in the BIOS, and on in the kernel (ie, no change
from the original test case).

So, this very well could be the fix.

Thanks,
Ben

> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 775c97a..a885295 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -293,7 +293,12 @@ static void __init check_multiple_madt(void)
>  
>  int __init acpi_table_init(void)
>  {
> -	acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
> +	acpi_status status;
> +
> +	status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
> +	if (ACPI_FAILURE(status))
> +		return 1;
> +
>  	check_multiple_madt();
>  	return 0;
>  }


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

