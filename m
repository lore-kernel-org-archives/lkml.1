Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYLLU4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYLLU4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYLLU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:56:16 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34313 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYLLU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:56:15 -0500
Date: Fri, 12 Dec 2008 20:56:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] video: mbp_nvidia_bl: Add support for MacBook 5, MacBook Air 2, and MacBook Pro 5
Message-ID: <20081212205609.GA28485@srcf.ucam.org>
References: <4942CE33.2020403@inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4942CE33.2020403@inf.tu-dresden.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 09:48:51PM +0100, Mario Schwalbe wrote:

> Known Bugs:
>     * MacBook Pro 5:
>          Initial brightness after bootup is the last recently used
>          brightness (in Mac OSX), while the firmware reports maximum.
>          Impossible to fix.

In that case, why not read the firmware value and then set that 
explicitly on driver load? Having the driver be in sync with the 
hardware is better than avoiding a brightness change on boot.

> +static int intel_chipset_get_intensity(struct backlight_device *bd)
>  {
>  	outb(0x03, 0xb3);
>  	outb(0xbf, 0xb2);
>  	return inb(0xb3) >> 4;
>  }

Just to absolutely clarify, this is intel chipset as in motherboard 
chipset and not graphics chipset, right? A comment to make that clear 
would be good - it left me a little confused at first. Other than that, 
it looks good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
