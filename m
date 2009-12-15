Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbZLOAwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbZLOAwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbZLOAwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:52:39 -0500
Received: from kroah.org ([198.145.64.141]:47977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067AbZLOAwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:52:36 -0500
Date: Mon, 14 Dec 2009 16:52:16 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
Message-ID: <20091215005216.GA9309@kroah.com>
References: <20091211212646.GB6624@kroah.com>
 <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 04:39:37PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 11 Dec 2009, Greg KH wrote:
> >
> > Here is the big USB merge for the 2.6.33-git tree.
> 
> I haven't bisected this yet, but something bad has happened to the USB 
> printer connected to Tove's computer since 2.6.32. Current -git doesn't 
> work, 2.6.32 works fine.
> 
> The USB pull is obviously an easy suspect, but on the other hand the code 
> still sees the printer - but for some reason Fedora-11 print manager still 
> complains about it perhaps being unconnected (and is unable to see any 
> printer if I try to go into "Printer admin" and remove and add the 
> printer)..

Any kind of kernel log messages?  This would be a USB 2.0 device, right?

> Booting back into 2.6.32 gets me a fine working printer again.
> 
> Does this ring a bell for anybody? The bisect is ongoing, but it will take 
> some time (at least 12 more compiles and reboots - I just started).

Hm, I just tried to print from mine on your latest tree, and I have a
stream of:
	[440651.362550] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440656.363409] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440661.364296] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440666.365009] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440677.692298] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440682.693080] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440687.697054] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440692.697784] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
	[440697.698653] usb 4-1.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1

messages in the log, which doesn't seem good.

Alan, any ideas?

thanks,

greg k-h
