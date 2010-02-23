Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0BWBzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:55:11 -0500
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:58798 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab0BWBzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:55:08 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 23 Feb 2010 03:55:04 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002221013480.1656-100000@iolanthe.rowland.org> <201002222035.36043.anssi.hannula@iki.fi> <201002230026.02941.oliver@neukum.org>
In-Reply-To: <201002230026.02941.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002230355.04422.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tiistai 23 helmikuu 2010 01:26:02 Oliver Neukum wrote:
> Am Montag, 22. Februar 2010 19:35:35 schrieb Anssi Hannula:
> > On maanantai 22 helmikuu 2010 17:28:36 Alan Stern wrote:
> > > The major difference between the logs is in the way the data get
> > > divided up into packets.  In both the successful logs, there are
> > > 
> > > sequences of bulk-OUT packets with lengths like:
> > > 	44, 1, 15, 1, 13
> > > 
> > > where the unsuccessful transfer just has a single packet of length 74.
> > > Also, the successful transfers show a lot of bulk-IN traffic where the
> > > unsuccessful transfer doesn't have any.  I don't know if that is
> > > relevant, however.
> > > 
> > > No other differences stand out.
> > 
> > I guess that would suggest that the device doesn't allow the
> > initialization data to be broken into packets arbitrarily (though some
> > differences seem allowed, as the windows driver transmits them
> > differently).
> 
> Hi,
> 
> let's try testing this hypothesis. Can you change the following line in
> usb_serial_probe():
> 		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL))
> 			goto probe_error;
> 
> to:
> 
> 		if (kfifo_alloc(&port->write_fifo, 64, GFP_KERNEL))
> 			goto probe_error;
> 
> This may shed some light on the behavior.

No effect.

However, I added more sleep(1) calls to gobi_loader, now between every magicX 
string and firmware files (therefore ensuring the data gets flushed to the 
device at those points). Now the upload was successful.

-- 
Anssi Hannula
