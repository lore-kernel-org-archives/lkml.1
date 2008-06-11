Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbYFKPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbYFKPjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYFKPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:39:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54188 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYFKPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:39:06 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
Date: Wed, 11 Jun 2008 17:39:23 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <484D070E.9050707@gmail.com> <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111739.24421.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 11 Juni 2008 16:13:43 schrieb Jiri Kosina:
> On Mon, 9 Jun 2008, Jiri Slaby wrote:
> 
> > > > static const struct hid_device_id hid_blacklist[] = {
> > > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > > > USB_DEVICE_ID_MX3000_RECEIVER) },
> > > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
> > > > },
> > > > +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > > > USB_DEVICE_ID_S510_RECEIVER_2) },
> > > >  	{ }
> > > >  };
> > > This shouldn't be needed as soon as the userspace supports the proper module
> > > autoloading, right?
> > This is needed to tell generic drivers not to bind these, its' generic
> > blacklist. I have no idea how this could be done better with current
> > drivers/base/.
> 
> Hmm ... but if we make sure that the order in `modules.order' puts all the 
> specialized drivers before the generic one, the binding should be done 
> correctly even without blacklist, right?

No. You might have two devices connected. The first correctly triggers
the loading of the generic driver. The second would first load the specialised
driver but the already loaded driver will be faster.

	Regards
		Oliver

