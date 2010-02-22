Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0BVSfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:35:41 -0500
Received: from sypressi.dnainternet.net ([83.102.40.135]:36735 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0BVSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:35:39 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.033
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Mon, 22 Feb 2010 20:35:35 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002221013480.1656-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002221013480.1656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222035.36043.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On maanantai 22 helmikuu 2010 17:28:36 Alan Stern wrote:
> On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > > > If I additionally insert a one-second delay before the fd is closed,
> > > > I get this usbmon log:
> > > > http://stuff.onse.fi/gobi2000/gobi-regression5.mon.log
> > > > 
> > > > The firmware upload is still unsuccessful.
> > > 
> > > If I use the option driver instead of qcserial, the firmware upload is
> > > always successful (without any added delays needed). The usbmon log for
> > > that case can be found here:
> > > http://stuff.onse.fi/gobi2000/gobi-regression6.mon.log
> > 
> > I installed 2.6.31.12 to get a usbmon log with qcserial before the
> > regression as well (without delays, upload successful):
> > http://stuff.onse.fi/gobi2000/gobi-regression7.mon.log
> 
> The major difference between the logs is in the way the data get
> divided up into packets.  In both the successful logs, there are
> sequences of bulk-OUT packets with lengths like:
> 
> 	44, 1, 15, 1, 13
> 
> where the unsuccessful transfer just has a single packet of length 74.
> Also, the successful transfers show a lot of bulk-IN traffic where the
> unsuccessful transfer doesn't have any.  I don't know if that is
> relevant, however.
> 
> No other differences stand out.

I guess that would suggest that the device doesn't allow the initialization 
data to be broken into packets arbitrarily (though some differences seem 
allowed, as the windows driver transmits them differently).

Does this mean a tty interface is ill-suited for the microcode upload, and 
instead qcserial should use the kernel's generic microcode upload mechanism or 
the userspace should use libusb to do it?

Any idea what could be causing the hang, then? The WARNING that appears when 
interrupting the hung gobi_loader is for serial_unthrottle() being called 
while usb_serial_port->port.count == 0.

-- 
Anssi Hannula
