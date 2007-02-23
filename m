Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXBWSMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXBWSMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXBWSMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:12:01 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:29674 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932498AbXBWSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:12:01 -0500
Date: Fri, 23 Feb 2007 13:11:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Duncan Sands <duncan.sands@math.u-psud.fr>
cc: Pete Zaitcev <zaitcev@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>
Subject: Re: [linux-usb-devel] [PATCH 2/2] usbatm: Detect usb device shutdown
 and ignore failed urbs.
In-Reply-To: <200702231805.44397.duncan.sands@math.u-psud.fr>
Message-ID: <Pine.LNX.4.44L0.0702231306450.14262-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Duncan Sands wrote:

> Thanks Alan.  The original question was: if an urb fails with an error,
> is there any point in resubmitting it after a delay (which is what the
> driver usually does) if the error was -ESHUTDOWN?  It sounds like there
> is no point to it.

No, there isn't.

>  And if the device is not disconnected, then it could
> even be harmful since the urb will be resubmitted endlessly...  While on
> the topic, are there any other error codes for which an urb should not be
> resubmitted?

Let's see...  ENOENT and ECONNRESET indicate the URB was unlinked, so you
probably don't want to resubmit it.  EPIPE indicates a problem on the 
device end, so you would want to fix the problem before resubmitting (at 
the very least you would want to clear the halt).  EOVERFLOW is 
questionable; if the device sent too much data once then it might do so 
again.  Ditto for EREMOTEIO (the device sent too little data).  ENODEV 
means the device was removed, so you definitely don't want to resubmit.

Alan Stern

