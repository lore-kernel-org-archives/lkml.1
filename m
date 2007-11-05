Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbXKED4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbXKED4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbXKED4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:56:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49060 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXKED4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:56:41 -0500
Date: Sun, 4 Nov 2007 19:58:55 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: device struct bloat
Message-ID: <20071105035855.GA25511@kroah.com>
References: <20071103124823.6059640e@shemminger-laptop> <1194208158.5911.63.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194208158.5911.63.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 09:29:18PM +0100, Peter Zijlstra wrote:
> 
> On Sat, 2007-11-03 at 12:48 -0700, Stephen Hemminger wrote:
> > The sizeof(struct device) is way too big, especially in the network device case.
> > We want to support 1000's of device's and the change from class_device to
> > net_device has caused needless bloat.
> > 
> > sizeof(struct device) = 272
> > sizeof(struct class_device) = 92
> >   * not the class_id in class_device could also be removed or changed to
> >      a ptr, since it is redundant for net_devices.
> 
> The thing that surprised me most was that it contains a struct
> semaphore, Greg, is that really needed?

Yes, it serializes bind and unbind stuff for the device.  There are
comments about it in drivers/base/dd.c if you want to look into it.

thanks,

greg k-h
