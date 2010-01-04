Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902Ab0ADUGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0ADUGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0ADUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:06:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:56894 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0ADUGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:06:16 -0500
Date: Mon, 4 Jan 2010 12:04:36 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Need to take dev->sem, do it directly or use wrapper?
Message-ID: <20100104200436.GA22515@suse.de>
References: <20100104185023.GA2597@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104185023.GA2597@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 10:50:23AM -0800, Dmitry Torokhov wrote:
> Greg,
> 
> I was looking at restructuring serio a bit and rely more on the
> infrastructure in the drivre core now that it is more flexible. It all
> looks good except for one detail - serio provides "reconnect" method
> which allows user to reinitialize a port whithout tearing down its
> children input devices. To properly serialize with probe(), remove() and
> other bus operations I'd need to take dev->sem semaphore. I(s bus code
> allowed to do this? Can I do it directly or we need to add a wrapper
> (like device_serialize_access(dev, bool))?

Adding a wrapper would be best to do.

thanks,

greg k-h
