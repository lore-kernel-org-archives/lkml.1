Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BVP2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:28:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43427 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753857Ab0BVP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:28:37 -0500
Date: Mon, 22 Feb 2010 10:28:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Anssi Hannula <anssi.hannula@iki.fi>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <dvomlehn@cisco.com>, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <201002220121.53882.anssi.hannula@iki.fi>
Message-ID: <Pine.LNX.4.44L0.1002221013480.1656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Anssi Hannula wrote:

> > > If I additionally insert a one-second delay before the fd is closed, I
> > > get this usbmon log:
> > > http://stuff.onse.fi/gobi2000/gobi-regression5.mon.log
> > > 
> > > The firmware upload is still unsuccessful.
> > 
> > If I use the option driver instead of qcserial, the firmware upload is
> > always successful (without any added delays needed). The usbmon log for
> > that case can be found here:
> > http://stuff.onse.fi/gobi2000/gobi-regression6.mon.log
> 
> I installed 2.6.31.12 to get a usbmon log with qcserial before the regression 
> as well (without delays, upload successful):
> http://stuff.onse.fi/gobi2000/gobi-regression7.mon.log

The major difference between the logs is in the way the data get
divided up into packets.  In both the successful logs, there are 
sequences of bulk-OUT packets with lengths like:

	44, 1, 15, 1, 13

where the unsuccessful transfer just has a single packet of length 74.  
Also, the successful transfers show a lot of bulk-IN traffic where the 
unsuccessful transfer doesn't have any.  I don't know if that is 
relevant, however.

No other differences stand out.

Alan Stern

