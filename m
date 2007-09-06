Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbXIFWkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbXIFWkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbXIFWke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:40:34 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:47058 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXIFWkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:40:33 -0400
Subject: [PATCH] Remove pointless NULL pointer check in
	drivers/usb/storage/shuttle_usbat.c.
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
In-Reply-To: <20070904210630.GD4117@kernel.dk>
References: <46DD1661.4070500@gmail.com> <20070904110651.GB5126@kernel.dk>
	 <1188935869.19079.3.camel@odie.local>  <20070904210630.GD4117@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 07 Sep 2007 00:33:29 +0200
Message-Id: <1189118009.19079.22.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tir, 04 09 2007 kl. 23:06 +0200, skrev Jens Axboe:
> On Tue, Sep 04 2007, Simon Holm Thøgersen wrote:
> > tir, 04 09 2007 kl. 13:06 +0200, skrev Jens Axboe:
> > > On Tue, Sep 04 2007, Micah Gruber wrote:
> > > > This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> > > > 
> > > > Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> > > 
> > > Be careful with stuff like that, if you actually look at the code, a us
> > > == NULL doesn't seem to be possible (or usbat_flash_transport() would
> > > have oopsed before).
> > > 
> > If that is true, then
> >         if (!us)
> >                 return USB_STOR_TRANSPORT_ERROR;
> > is utterly pointless.
> 
> Well that was the point I was trying to make, that test and return
> should be deleted instead.
> 
I guess we agree that we want the following then.


If us would ever be NULL, the function would have oopsed already before
the check.

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---

--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -190,9 +190,6 @@ static int usbat_check_status(struct us_data *us)
 	unsigned char *reply = us->iobuf;
 	int rc;
 
-	if (!us)
-		return USB_STOR_TRANSPORT_ERROR;
-
 	rc = usbat_get_status(us, reply);
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_FAILED;


