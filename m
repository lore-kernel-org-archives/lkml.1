Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZJSPhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZJSPhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZJSPhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:37:00 -0400
Received: from mga12.intel.com ([143.182.124.36]:37707 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756548AbZJSPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,585,1249282800"; 
   d="scan'208";a="200780696"
Date: Mon, 19 Oct 2009 17:38:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>
Subject: Re: [PATCH 1/7] mfd: pcf50633 disable unnecessary shutdown on
 lowsys
Message-ID: <20091019153816.GE3885@sortiz.org>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I applied all patches except patch 5, on which I commented about.
Also, patch 3 didnt have any changelog execpt the SOB lines. I expect to get
something even for such trivial patches.

Thanks for your work.

Cheers,
Samuel.

On Wed, Oct 14, 2009 at 02:12:30AM +0400, Paul Fertser wrote:
> On gta02 hardware revision A5 it can actually bring the system down
> during normal operating conditions so we disable it.
> 
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  drivers/mfd/pcf50633-core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index d26d774..6efe5c3 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -345,6 +345,9 @@ static void pcf50633_irq_worker(struct work_struct *work)
>  		goto out;
>  	}
>  
> +	/* defeat 8s death from lowsys on A5 */
> +	pcf50633_reg_write(pcf, PCF50633_REG_OOCSHDWN,  0x04);
> +
>  	/* We immediately read the usb and adapter status. We thus make sure
>  	 * only of USBINS/USBREM IRQ handlers are called */
>  	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
> -- 
> 1.6.0.6
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
