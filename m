Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbZDNRCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbZDNRCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbZDNRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:02:20 -0400
Received: from kroah.org ([198.145.64.141]:56525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757033AbZDNRCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:02:19 -0400
Date: Tue, 14 Apr 2009 09:59:05 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: device_for_each_child() before device_add() doesn't work
Message-ID: <20090414165905.GA25645@kroah.com>
References: <49E4BFD0.2020302@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4BFD0.2020302@csr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:54:40PM +0100, David Vrabel wrote:
> Calling device_for_each_child() on a device that has yet to be added
> (with device_add()) used to work.  UWB subsystem currently tries to do this.
> 
> Since "driver core: move klist_children into private structure"[1] this
> no longer works (an oops occurs in device_for_each_chid()).  Is it
> something that ought to work? Or should the UWB subsystem be changed to
> not do this?

Why would you call device_for_each_child() if you have never added it to
the bus?  How would you expect that to work, as there will never be any
children for it?

thanks,

greg k-h
