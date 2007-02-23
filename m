Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXBWRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXBWRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154AbXBWRF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:05:26 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:50975 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144AbXBWRFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:05:25 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH 2/2] usbatm: Detect usb device shutdown and ignore failed urbs.
Date: Fri, 23 Feb 2007 18:05:44 +0100
User-Agent: KMail/1.9.6
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>
References: <Pine.LNX.4.44L0.0702231111550.18246-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702231111550.18246-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231805.44397.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 February 2007 17:16:24 Alan Stern wrote:
> On Fri, 23 Feb 2007, Duncan Sands wrote:
> 
> > if you get ESHUTDOWN, does that mean that you are about to be disconnected,
> > i.e. the disconnect method is about to be called?  Or is it possible for the
> > device to just sit there disabled, but not disconnected?
> 
> It is possible to receive ESHUTDOWN without being disconnected.  For 
> instance, a race with suspend could cause it to happen (although if your 
> driver is written correctly that race should never occur).  Another more 
> likely scenario is that you have an active URB while calling 
> usb_set_interface(); the endpoints for the old altsetting get disabled and 
> the URB returns with an ESHUTDOWN error.

Thanks Alan.  The original question was: if an urb fails with an error,
is there any point in resubmitting it after a delay (which is what the
driver usually does) if the error was -ESHUTDOWN?  It sounds like there
is no point to it.  And if the device is not disconnected, then it could
even be harmful since the urb will be resubmitted endlessly...  While on
the topic, are there any other error codes for which an urb should not be
resubmitted?

Thanks again,

Duncan.
