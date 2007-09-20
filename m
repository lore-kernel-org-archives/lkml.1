Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbXITSSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbXITSSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXITSSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:18:01 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:54598 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095AbXITSSA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:18:00 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Thu, 20 Sep 2007 20:17:50 +0200
User-Agent: KMail/1.9.7
References: <200709192014.08443.elendil@planet.nl> <46F2A0E9.9000603@gmail.com> <46F2AE16.9080803@gmail.com>
In-Reply-To: <46F2AE16.9080803@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Maciek Rutecki <maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709202017.50934.elendil@planet.nl>
X-OriginalArrivalTime: 20 Sep 2007 18:17:51.0159 (UTC) FILETIME=[8E2FB470:01C7FBB2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, you wrote:
> Please try this patch.

Works. All states are now listed again.
I've not tested suspend to disk, but suspend to ram and power off work fine.

> +printk(KERN_INFO PREFIX "(supports");
>  #ifdef CONFIG_SUSPEND
> -       printk(KERN_INFO PREFIX "(supports");
>         for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {

Isn't there a risk now that we now end up printing
   ACPI: (supports)
if CONFIG_SUSPEND is not enabled and >S4 is not supported?

Or, more probably, it would print
   ACPI: (supports S5)
as it is unlikely that "off" is not supported :-)

Maybe S0 should be taken outside the #ifdef and the loop as that state is 
also basically always there?

Thanks,
FJP
