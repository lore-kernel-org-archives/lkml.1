Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZGAK4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZGAK4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZGAK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:56:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37863 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZGAK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:56:34 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Wed, 1 Jul 2009 12:56:46 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org> <200907011301.06574.ars3n@yandex.ru>
In-Reply-To: <200907011301.06574.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011256.47550.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juli 2009 11:01:06 schrieb Arseniy Lartsev:
> On Wednesday 01 July 2009 01:01:00 Alan Stern wrote:
> > This looks like your problem.  Low-speed devices are not allowed to
> > have bulk endpoints.  Linux internally changes them to interrupt
> > endpoints with interval = 1 and maxpacket size no larger than 8.
>
> Maybe this device is a little "buggy". But Linux should support buggy
> devices as well.

Yes, it should. We just needed to understand why it failed.


> +		ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in : acm->dev->ep_out)
> +				[usb_pipeendpoint(acm->rx_endpoint)];
> +		if (usb_endpoint_xfer_int(&ep->desc))
> +			usb_fill_int_urb(rcv->urb, acm->dev,
> +					 acm->rx_endpoint,
> +					 buf->base,
> +					 acm->readsize,
> +					 acm_read_bulk, rcv, 0xff);

The patch is good except for this.
We should make sure this interval matches usbcore's value.
Would you care to redo it with that change?

	Regards
		Oliver

