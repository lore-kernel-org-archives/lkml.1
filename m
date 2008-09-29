Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYI2WVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYI2WVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYI2WV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:21:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48305 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYI2WV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:21:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: BUG: Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a makes special keys on my T21 unusable after resume
Date: Tue, 30 Sep 2008 00:25:52 +0200
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
References: <20080929221628.GA3082@localdomain>
In-Reply-To: <20080929221628.GA3082@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809300025.52904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 of September 2008, Karol Lewandowski wrote:
> Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a causes my Thinkpad T21
> to no longer generate any hotkey events (e.g. suspend fn-f4, switch-output
> fn-f7, etc.) after resume.
> 
> It's regression from 2.6.25.  2.6.26 and 2.6.27-rc7 are broken,
> reverting that commit on 2.6.27-rc7 makes keys work again.
> 
> Thanks.
> 
> [Rafael added for regression tracking ;]
> 
> 
> commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Jun 6 11:49:33 2008 -0400
> 
>     ACPI: EC: Use msleep instead of udelay while waiting for event.
>     
>     http://bugzilla.kernel.org/show_bug.cgi?id=10724
>     
>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index 0924992..5622aee 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -194,7 +194,7 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
>  		while (time_before(jiffies, delay)) {
>  			if (acpi_ec_check_status(ec, event))
>  				return 0;
> -			udelay(ACPI_EC_UDELAY);
> +			msleep(1);
>  		}
>  	}
>  	pr_err(PREFIX "acpi_ec_wait timeout, status = 0x%2.2x, event = %s\n",

Can you see if the patch at
http://bugzilla.kernel.org/attachment.cgi?id=18044&action=view
(against current -git) helps?

Thanks,
Rafael
