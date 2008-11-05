Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYKEKWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYKEKWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYKEKWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:22:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45771 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754763AbYKEKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:22:16 -0500
Date: Wed, 5 Nov 2008 11:00:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
Message-ID: <20081105100050.GB1424@ucw.cz>
References: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-03 20:57:15, Steven Noonan wrote:
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
>  				msleep(10);

If the bios is non-broken, it will acknowledge hndover and it takes
10msec total.

If the bios is broken, 5 seconds may be handy.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
