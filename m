Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZGALho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZGALho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZGALhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:37:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45137 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZGALhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:37:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arseniy Lartsev <ars3n@yandex.ru>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Wed, 1 Jul 2009 13:37:48 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org> <200907011256.47550.oliver@neukum.org> <200907011525.00689.ars3n@yandex.ru>
In-Reply-To: <200907011525.00689.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011337.48901.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juli 2009 13:24:55 schrieb Arseniy Lartsev:
> On Wednesday 01 July 2009 14:56:46 Oliver Neukum wrote:
> > > +		ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in :
> > > acm->dev->ep_out) +				[usb_pipeendpoint(acm->rx_endpoint)];
> > > +		if (usb_endpoint_xfer_int(&ep->desc))
> > > +			usb_fill_int_urb(rcv->urb, acm->dev,
> > > +					 acm->rx_endpoint,
> > > +					 buf->base,
> > > +					 acm->readsize,
> > > +					 acm_read_bulk, rcv, 0xff);
> >
> > The patch is good except for this.
> > We should make sure this interval matches usbcore's value.
> > Would you care to redo it with that change?
>
> Am I right that 0xff here should be changed to ep->desc.bInterval (and to
> epwrite->bInterval in the other call to usb_fill_int_urb)?

Yes, exactly. Please add greg@kroah.com into CC, add a Signed-off-by line
and resend.

	Regards
		Oliver

