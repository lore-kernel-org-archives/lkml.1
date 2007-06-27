Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbXF0Hf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbXF0Hf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXF0HfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:35:14 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:57852 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXF0HfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:35:12 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Keith Chew" <keith.chew@gmail.com>
Subject: Re: [linux-usb-devel] usb_fill_bulk_urb() broken for USB1.1?
Date: Wed, 27 Jun 2007 09:35:14 +0200
User-Agent: KMail/1.9.7
Cc: linux-usb-devel@lists.sourceforge.net, "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com> <200706270827.50698.oliver@neukum.org> <20f65d530706270030y5650e302yc5136adc0ac8dd46@mail.gmail.com>
In-Reply-To: <20f65d530706270030y5650e302yc5136adc0ac8dd46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270935.14657.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Juni 2007 schrieb Keith Chew:
> Hi Oliver
> 
> >
> > What do you use as arguments for usb_fill_bulk_urb() ? One of the sanity tests
> > in usb_submit_urb() is triggered.
> >
> 
> Usage:
> 
> 	usb_fill_bulk_urb(macp->intr_urb, macp->usb,
> 		usb_rcvbulkpipe(macp->usb, EP_INT_IN),
> 		macp->IntEPBuffer, MAX_EPINT_BUFFER,
> 		zd1211_intr_cb, macp);

See Pete's post.

You are initialising an interrupt urb with an initializer for
a bulk urb. The behavior is undefined. In older kernels
by random chance a sensible interval was set.

You need to use the correct initializer and the correct interval,
which usually can be read from the device's descriptors.

	Regards
		Oliver

