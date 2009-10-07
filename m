Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZJGFBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZJGFBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZJGFBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:01:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60366 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZJGFBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:01:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Wed, 7 Oct 2009 07:02:31 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20091006145413.9431.47083.stgit@localhost.localdomain> <20091006150641.9431.67880.stgit@localhost.localdomain>
In-Reply-To: <20091006150641.9431.67880.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200910070702.32266.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9754R16020940

Am Dienstag, 6. Oktober 2009 17:06:46 schrieb Alan Cox:> +++ b/drivers/usb/serial/opticon.c> @@ -498,12 +498,12 @@ static int opticon_resume(struct usb_interface *intf)> Â Â Â Â Â Â Â Â struct usb_serial_port *port = serial->port[0];> Â Â Â Â Â Â Â Â int result;> Â > -Â Â Â Â Â Â Â mutex_lock(&port->mutex);> +Â Â Â Â Â Â Â mutex_lock(&port->port.mutex);> Â Â Â Â Â Â Â Â if (port->port.count)> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);> Â Â Â Â Â Â Â Â else> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â result = 0;> -Â Â Â Â Â Â Â mutex_unlock(&port->mutex);> +Â Â Â Â Â Â Â mutex_unlock(&port->port.mutex);> Â Â Â Â Â Â Â Â return result;> Â }
We will need some generic way to autoresume from open.Resume will need to lock against open() and need to be calledfrom within open(). Any ideas for an unugly interface?
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
