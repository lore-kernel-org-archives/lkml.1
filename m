Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYIDLtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYIDLtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYIDLtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:49:16 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34821 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbYIDLtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:49:15 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Denys Fedoryshchenko <denys@visp.net.lb>
Subject: Re: USB recursive locking, 2.6.27-rc5 while keyboard unplug/plug
Date: Thu, 4 Sep 2008 13:50:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200809041439.05542.denys@visp.net.lb>
In-Reply-To: <200809041439.05542.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041350.29240.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 04 September 2008 13:39:04 schrieb Denys Fedoryshchenko:
> Got a warning, while plugging/unplugging keyboard.

Please edit drivers/hid/usbhid/hid-core.c
static void hid_cease_io(struct usbhid_device *usbhid)
{
	del_timer(&usbhid->io_retry);
	usb_kill_urb(usbhid->urbin);
	usb_kill_urb(usbhid->urbctrl);
	usb_kill_urb(usbhid->urbout);
	flush_scheduled_work();
}

to remove the flush_scheduled_work() and try again.

	Regards
		Oliver
