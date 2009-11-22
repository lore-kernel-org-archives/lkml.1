Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZKVWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZKVWRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 17:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZKVWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 17:17:37 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37995 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752748AbZKVWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 17:17:36 -0500
Date: Sun, 22 Nov 2009 17:17:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
In-Reply-To: <4B0971F2.8020702@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0911221714160.31173-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009, Simon Arlott wrote:

> I've tried sending 64 and 2048 bytes at a time, with the same speed
> (4ms and 128ms), so that time is just a coincidence.

These timings indicate that one packet is getting transmitted every 4 
frames.  In theory the slowness could be caused by either the host 
controller or the device, but you'd need a bus analyzer to tell which.  
Certainly there's no good reason for the controller to run that slowly, 
but there's also no good reason for the device to run that slowly only 
with OHCI.

> Submitting it all as multiple asynchronous URBs in one go doesn't help
> either. I've been trying to get EHCI working too (via two different
> high speed hubs) but that's not working even if I add long delays.

Have you tried using a non-high-speed hub, or forcing the port into 
full speed and adding a hub?  That is, does the presence of a hub with 
OHCI make any difference?

Alan Stern

