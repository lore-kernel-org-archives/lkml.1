Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0BVX0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:26:19 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:59578 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0BVX0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:26:17 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 23 Feb 2010 00:26:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002221013480.1656-100000@iolanthe.rowland.org> <201002222035.36043.anssi.hannula@iki.fi>
In-Reply-To: <201002222035.36043.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002230026.02941.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. Februar 2010 19:35:35 schrieb Anssi Hannula:
> On maanantai 22 helmikuu 2010 17:28:36 Alan Stern wrote:

> > The major difference between the logs is in the way the data get
> > divided up into packets.  In both the successful logs, there are
> > sequences of bulk-OUT packets with lengths like:
> > 
> > 	44, 1, 15, 1, 13
> > 
> > where the unsuccessful transfer just has a single packet of length 74.
> > Also, the successful transfers show a lot of bulk-IN traffic where the
> > unsuccessful transfer doesn't have any.  I don't know if that is
> > relevant, however.
> > 
> > No other differences stand out.
> 
> I guess that would suggest that the device doesn't allow the initialization 
> data to be broken into packets arbitrarily (though some differences seem 
> allowed, as the windows driver transmits them differently).

Hi,

let's try testing this hypothesis. Can you change the following line in
usb_serial_probe():
		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL))
			goto probe_error;

to:

		if (kfifo_alloc(&port->write_fifo, 64, GFP_KERNEL))
			goto probe_error;

This may shed some light on the behavior.

	Regards
		Oliver
