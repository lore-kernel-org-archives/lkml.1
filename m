Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYJUPmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYJUPmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYJUPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:42:28 -0400
Received: from mail.tpi.com ([198.107.51.143]:2750 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYJUPm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:42:27 -0400
Message-ID: <48FDF864.9070705@tpi.com>
Date: Tue, 21 Oct 2008 09:42:28 -0600
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       286977@bugs.launchpad.net
Subject: Re: [PATCH] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
References: <E1KsI6R-0006gT-PJ@bioshock.netsplit.com>
In-Reply-To: <E1KsI6R-0006gT-PJ@bioshock.netsplit.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> The ipmi_devintf module contains the userspace interface for IPMI
> devices, yet will not be loaded automatically with a system
> interface handler driver.
> 
> Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by
> the ipmi_si driver, so that userspace knows of the recommendation.
> 
> Signed-off-by: Scott James Remnant <scott@ubuntu.com>
> ---
>  drivers/char/ipmi/ipmi_devintf.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index 64e1c16..ecaf369 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
>  MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
> +MODULE_ALIAS("platform:ipmi_si");

Seems like a candidate for the stable kernel. If you add the line:

Cc: stable@kernel.org

it will happen automagically when Linus merges it into his tree. Can you
resubmit with this line added?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
