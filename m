Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZBWIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZBWIJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZBWIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:09:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbZBWIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:09:15 -0500
Date: Mon, 23 Feb 2009 00:08:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Danny Kukawka <dkukawka@suse.de>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 8250_pnp.c: add another serial Wacom tablet
Message-Id: <20090223000855.e94765d9.akpm@linux-foundation.org>
In-Reply-To: <200902222016.06946.dkukawka@suse.de>
References: <200902222016.06946.dkukawka@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 20:16:06 +0100 Danny Kukawka <dkukawka@suse.de> wrote:

> From: Danny Kukawka <dkukawka@suse.de>
> Subject: 8250_pnp.c: add another Wacom tablet
> 
> Add another serial Wacom tablet with pnp_id: WACF009.
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>
> --
>  8250_pnp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
> index bbcfc26..6db9f13 100644
> --- a/drivers/serial/8250_pnp.c
> +++ b/drivers/serial/8250_pnp.c
> @@ -333,6 +333,7 @@ static const struct pnp_device_id pnp_dev_table[] = {
>  	{       "WACF006",              0       },
>  	{       "WACF007",              0       },
>  	{       "WACF008",              0       },
> +	{       "WACF009",              0       },
>  	/* Compaq touchscreen */
>  	{       "FPI2002",              0 },
>  	/* Fujitsu Stylistic touchscreens */

I already had the below queued.  Can you review it please?

Alan seems to be having a bit of quiet time so I think I'll merge this
into 2.6.29.


From: Matthew Garrett <mjg59@srcf.ucam.org>

Add new Wacom device IDs to the 8250_pnp serial driver, to support
autoconfig on some newer tablet PCs.  Also add a comment to clarify that
the FUJ02E6 device is a custom protocol, not a Wacom tablet.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pnp.c~serial-update-pnp-ids drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-update-pnp-ids
+++ a/drivers/serial/8250_pnp.c
@@ -333,6 +333,10 @@ static const struct pnp_device_id pnp_de
 	{       "WACF006",              0       },
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
+	{       "WACF009",              0       },
+	{       "WACF00A",              0       },
+	{       "WACF00B",              0       },
+	{       "WACF00C",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -346,8 +350,9 @@ static const struct pnp_device_id pnp_de
 	{       "FUJ02B8",              0 },
 	{       "FUJ02B9",              0 },
 	{       "FUJ02BC",              0 },
-	/* Fujitsu Wacom Tablet PC devices */
+	/* Fujitsu Wacom Tablet PC device */
 	{	"FUJ02E5",		0	},
+	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
_

