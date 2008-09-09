Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYIIEpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYIIEpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYIIEo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:44:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbYIIEo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:44:59 -0400
Date: Mon, 8 Sep 2008 21:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Noonan <steven.noonan@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/usb/host/pci-quirks.c: wait for EHCI
 handoff far too long in quirk_usb_disable_ehci()
Message-Id: <20080908214426.49626bf0.akpm@linux-foundation.org>
In-Reply-To: <1220747393-10401-2-git-send-email-steven@uplinklabs.net>
References: <1220747393-10401-1-git-send-email-steven@uplinklabs.net>
	<1220747393-10401-2-git-send-email-steven@uplinklabs.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-usb)

On Sat,  6 Sep 2008 17:29:53 -0700 Steven Noonan <steven.noonan@uplinklabs.net> wrote:

> This patch fixes a very noticeable bootup delay on some
> systems (in my particular case, an HP dv5178us). The
> problem is caused by a buggy BIOS which doesn't properly
> announce that the handoff was completed.
> 
> The delay in the current version of pci-quirks.c is 5 seconds,
> which I've cut down to 0.5 seconds.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/usb/host/pci-quirks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index ae6e70e..9a3609a 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
>  			/* if boot firmware now owns EHCI, spin till
>  			 * it hands it over.
>  			 */
> -			msec = 5000;
> +			msec = 500;
>  			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
>  				tried_handoff = 1;
>  				msleep(10);

I guess it risks breaking someone else's system.  Or perhaps the number
was just grabbed out of the air.

Can we do a separate quirk just for that machine (and ones with the
same bug)?

