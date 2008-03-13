Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYCMPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYCMPgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYCMPgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:36:01 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42070 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969AbYCMPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:36:01 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 11:36:00 EDT
Date: Thu, 13 Mar 2008 16:35:14 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] atmel_lcdfb: wiring BGR to RGB color mode
Message-ID: <20080313163514.3615a35d@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <47D5450A.40500@atmel.com>
References: <47D5450A.40500@atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 15:35:14.0890 (UTC) FILETIME=[D54972A0:01C8851F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 15:26:18 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> The legacy atmel LCDC IP uses a non standard color mode,
> "BGR-555.1" instead "RGB-565". The major part of graphic stacks 
> for embedded systems uses only "RGB-565". It is possible to swap 
> LCD IOs instead of doing this bit swapping by software (See 
> application note AT91SAM9 LCD Controller
> http://www.atmel.com/dyn/resources/prod_documents/doc6300.pdf)

> -		var->red.offset = 0;
> +		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
> +			/* RGB:888 mode */
> +			var->red.offset = 16;
> +			var->blue.offset = 0;
> +		} else {
> +			/* BGR:888 mode */
> +			var->red.offset = 0;
> +			var->blue.offset = 16;
> +		}

Does RGB:565 always imply RGB:888 and vice versa?

If not, I think it would be better with separate flags for the possible
wirings:
   * 18-bit BGR-555.1 / 24-bit BGR-888
   * 16-bit RGB-565
   * 24-bit RGB-888

Or maybe I misunderstand something?

Haavard
