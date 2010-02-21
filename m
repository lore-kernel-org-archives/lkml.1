Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0BUVmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:42:16 -0500
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:57694 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301Ab0BUVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:42:15 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sun, 21 Feb 2010 23:42:12 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212342.12301.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sunnuntai 21 helmikuu 2010 23:28:54 Alan Stern wrote:
> On Sat, 20 Feb 2010, Oliver Neukum wrote:
> > Am Samstag, 20. Februar 2010 17:03:41 schrieb Anssi Hannula:
> > > > Can load usbserial with "debug=1"?
> > > 
> > > Here's the end of dmesg when running with that option:
> > > http://stuff.onse.fi/gobi2000/gobi-regression.dmesg.log
> > > 
> > > This is again with the gobi_loader with extra sleep added in the
> > > beginning. Otherwise it hangs (which is the actual original problem).
> > 
> > That log makes sure that the final cancellation comes from closing
> > the file. Is that a log of a working run?
> 
> Could this simply be one of those cases where the device file is closed
> just after the final write URB is submitted but before it can complete,
> so the URB gets cancelled and the data isn't transferred?

Seems so. I don't think that is the expected behaviour though (and of course 
it used to work).

And of course this doesn't explain why it hangs (and the WARNING) if I remove 
the sleep calls I added in gobi_loader.

-- 
Anssi Hannula
