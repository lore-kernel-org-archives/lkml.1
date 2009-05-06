Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZEFPs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZEFPs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZEFPsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:48:43 -0400
Received: from kroah.org ([198.145.64.141]:40831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZEFPsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:48:42 -0400
Date: Wed, 6 May 2009 08:45:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
	writes
Message-ID: <20090506154506.GB4941@kroah.com>
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com> <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org> <20090506164141.55c8978c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506164141.55c8978c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 04:41:41PM +0100, Alan Cox wrote:
> In other words never lie in the write_room method. Try to send data as
> early as possible, but don't queue data inefficiently when the port has
> plenty left to send.
> 
> The rules for write_room are simple
> 
> 	If you say you have space for X bytes you can't say you have room
> 	for less bytes unless those bytes have actually been written - no
> 	window shrinking so to speak.
> 
> If your write_room method works properly, and you fix the buffering logic
> then the rest will work. Probably we need usb/serial/buffer.c which has a
> generic implementation in then that can be used to replace the completely
> bogus hacks in most of the drivers.

I agree, this is the correct solution.

thanks,

greg k-h
