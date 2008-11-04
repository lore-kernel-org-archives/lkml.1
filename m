Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYKDFcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYKDFcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYKDFcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:32:42 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58661 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYKDFcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:32:42 -0500
Message-ID: <490FDE72.9060400@garzik.org>
Date: Tue, 04 Nov 2008 00:32:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
References: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
In-Reply-To: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> Instead of waiting a painful 5000ms, quirk_usb_disable_ehci() now does a
> 1000ms loop to wait for the BIOS to acknowledge the handoff.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg KH <greg@kroah.com>
> Cc: David Brownell <david-b@pacbell.net>
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/usb/host/pci-quirks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index ae6e70e..1968ba1 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
>  			/* if boot firmware now owns EHCI, spin till
>  			 * it hands it over.
>  			 */
> -			msec = 5000;
> +			msec = 1000;
>  			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
>  				tried_handoff = 1;

That tells us nothing about the original reason for choosing the 5000 
value, and what if any impact lowering the value has on those who 
thought 5000 was needed.

	Jeff



