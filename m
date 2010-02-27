Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967770Ab0B0D50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 22:57:26 -0500
Received: from kroah.org ([198.145.64.141]:34748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab0B0D5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 22:57:14 -0500
Date: Fri, 26 Feb 2010 19:56:39 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: werner@guyane.dyn-o-saur.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
Message-ID: <20100227035639.GA11680@kroah.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 04:42:53AM +0100, Markus Rechberger wrote:
> * http://lkml.org/lkml/2010/2/19/192
> .6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Greg KH <greg@kroah.com>
> 
> commit d4a4683ca054ed9917dfc9e3ff0f7ecf74ad90d6 upstream.
> 
> We need to only copy the data received by the device to userspace, not
> the whole kernel buffer, which can contain "stale" data.
> 
> Thanks to Marcus Meissner for pointing this out and testing the fix.
> 
> Reported-by: Marcus Meissner <meissner@suse.de>
> Tested-by: Marcus Meissner <meissner@suse.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> this patch breaks isochronous USBFS support, please revert that patch!
> 
> http://sundtek.de/images/tvtime-bildfehler.jpg
> 
> with the patch reverted:
> http://sundtek.de/images/tvtime-working.png
> 
> * Intel graphic flickers now

That is very strange.  What userspace program is using usbfs for video
feeds?  And why would it be relying on the invalid data on the end of an
urb?

thanks,

greg k-h
