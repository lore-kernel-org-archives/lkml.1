Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYDEOQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYDEOQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYDEOQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 10:16:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2978 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751937AbYDEOQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:16:12 -0400
Date: Sat, 5 Apr 2008 10:16:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was: 2.6.25-rc8-mm1]
In-Reply-To: <20080405043741.GA26420@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0804051013250.5030-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Greg KH wrote:

> > Here's the answer.  The bug was introduced when the definition of 
> > device_is_registered() in include/linux/device.h was changed.  The old 
> > definition returned 0 when called inside a driver's remove method for a 
> > device being unregistered, whereas the new definition returns 1.  I 
> > don't know when this change was made.
> 
> I've changed that in the -mm tree to make some PCI stuff much easier.  I
> didn't realize that USB was depending on when this was being set, sorry
> about it.
> 
> I like your fix better, it makes the code path much simpler :)

Well, it's not really any _simpler_, since all I did was interchange 
two lines of code.

But I agree this way is better.  It doesn't depend on the behavior of 
device_is_registered() in the ill-defined situation where the device is 
in the middle of being unregistered.

Alan Stern

