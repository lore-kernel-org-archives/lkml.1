Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZLBUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZLBUoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZLBUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:44:17 -0500
Received: from pancho.name ([92.48.73.7]:54051 "EHLO pancho.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZLBUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:44:16 -0500
Date: Wed, 2 Dec 2009 21:44:21 +0100
From: pancho horrillo <pancho@pancho.name>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
Message-ID: <20091202204421.GA1786@pancho.name>
References: <20091202191942.GA7362@pancho.name>
 <20091202193104.GB7362@pancho.name>
 <4B16C233.6020808@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B16C233.6020808@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 10:38:27PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> pancho horrillo wrote:
> 
> >Please, review and push the patch, if you deem it adequate.
> 
> >Thanks a bunch!
> 
>    That 'uint8_t' is for userspace, use 'u8' instead.
> 
> WBR, Sergei

Thanks for the coaching, Sergei!

BTW, there are about 4863 of uint8_t in the kernel sources :-)

Cheers,

pancho.

Signed-off-by: pancho horrillo <pancho@pancho.name>

diff -purN a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c	2009-11-10 01:32:31.000000000 +0100
+++ b/drivers/usb/misc/appledisplay.c	2009-12-02 20:05:00.000000000 +0100
@@ -72,8 +72,8 @@ struct appledisplay {
 	struct usb_device *udev;	/* usb device */
 	struct urb *urb;		/* usb request block */
 	struct backlight_device *bd;	/* backlight device */
-	char *urbdata;			/* interrupt URB data buffer */
-	char *msgdata;			/* control message data buffer */
+	u8 *urbdata;			/* interrupt URB data buffer */
+	u8 *msgdata;			/* control message data buffer */
 
 	struct delayed_work work;
 	int button_pressed;
-- 
pancho horrillo

To be conscious that
you are ignorant is a great step
to knowledge.

		Benjamin Disraeli
