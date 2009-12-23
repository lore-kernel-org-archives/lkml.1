Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZLWKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZLWKJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZLWKJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:09:19 -0500
Received: from pancho.name ([92.48.73.7]:37149 "EHLO pancho.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbZLWKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:09:16 -0500
Date: Wed, 23 Dec 2009 11:09:13 +0100
From: pancho horrillo <pancho@pancho.name>
To: Greg KH <greg@kroah.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
Message-ID: <20091223100913.GA3253@pancho.name>
References: <20091202191942.GA7362@pancho.name>
 <20091202193104.GB7362@pancho.name>
 <4B16C233.6020808@ru.mvista.com>
 <20091202204421.GA1786@pancho.name>
 <20091222192937.GA13974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222192937.GA13974@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 11:29:37AM -0800, Greg KH wrote:
[...]
> Care to resend this one with the proper changelog comment so that I can
> apply it?
> 
Sure.  Here it goes...  Please let me know if more editing is required.



brightness status is reported by the Apple Cinema Displays as an
'unsigned char' (u8) value, but the code used 'char' instead.

Note that he driver was developed on the PowerPC architecture,
where the two types are synonymous, which is not always the case.

Fixed that.  Otherwise the driver will interpret brightness
levels > 127 as negative, and fail to load.

Signed-off-by: pancho horrillo <pancho@pancho.name>
---
 drivers/usb/misc/appledisplay.c |    4 +-
 1 file changed, 2 insertions(+), 2 deletions(-)

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



> thanks,
really appreciated.  This is my very first (and tiny) contribution to
the linux kernel, even though I've been a user since the 1.2.x series,
back in '96.

> greg k-h

Happy hacking!

pancho.

-- 
pancho horrillo

To be conscious that
you are ignorant is a great step
to knowledge.

		Benjamin Disraeli
