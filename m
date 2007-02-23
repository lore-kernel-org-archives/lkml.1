Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXBWQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXBWQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXBWQQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:16:27 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:27913 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S933125AbXBWQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:16:27 -0500
Date: Fri, 23 Feb 2007 11:16:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Duncan Sands <duncan.sands@math.u-psud.fr>
cc: Pete Zaitcev <zaitcev@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>
Subject: Re: [linux-usb-devel] [PATCH 2/2] usbatm: Detect usb device shutdown
 and ignore failed urbs.
In-Reply-To: <200702231036.14048.duncan.sands@math.u-psud.fr>
Message-ID: <Pine.LNX.4.44L0.0702231111550.18246-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Duncan Sands wrote:

> if you get ESHUTDOWN, does that mean that you are about to be disconnected,
> i.e. the disconnect method is about to be called?  Or is it possible for the
> device to just sit there disabled, but not disconnected?

It is possible to receive ESHUTDOWN without being disconnected.  For 
instance, a race with suspend could cause it to happen (although if your 
driver is written correctly that race should never occur).  Another more 
likely scenario is that you have an active URB while calling 
usb_set_interface(); the endpoints for the old altsetting get disabled and 
the URB returns with an ESHUTDOWN error.

Alan Stern

