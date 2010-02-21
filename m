Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0BUV3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:29:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49966 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753291Ab0BUV2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:28:55 -0500
Date: Sun, 21 Feb 2010 16:28:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Anssi Hannula <anssi.hannula@iki.fi>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <dvomlehn@cisco.com>,
       <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <201002201919.10674.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, Oliver Neukum wrote:

> Am Samstag, 20. Februar 2010 17:03:41 schrieb Anssi Hannula:
> > > But something must kill your last URB.
> > > You are not using autosuspend are you?
> > 
> > Don't know, usbcore has autosuspend=2 and the gobi device has autosuspend=2 
> > and supports_autosuspend=1.
> 
> What is the content of "level"?
> 
> > > Can load usbserial with "debug=1"?
> > 
> > Here's the end of dmesg when running with that option:
> > http://stuff.onse.fi/gobi2000/gobi-regression.dmesg.log
> > 
> > This is again with the gobi_loader with extra sleep added in the beginning. 
> > Otherwise it hangs (which is the actual original problem).
> 
> That log makes sure that the final cancellation comes from closing
> the file. Is that a log of a working run?

Could this simply be one of those cases where the device file is closed 
just after the final write URB is submitted but before it can complete, 
so the URB gets cancelled and the data isn't transferred?

Alan Stern

