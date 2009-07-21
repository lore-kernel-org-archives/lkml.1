Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZGUCfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZGUCfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZGUCfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:35:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:55919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbZGUCfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:35:20 -0400
Date: Mon, 20 Jul 2009 19:11:26 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 47/54] Staging: hv: make gVmbusConnection.ChannelLock a
 real spinlock
Message-ID: <20090721021126.GB11051@suse.de>
References: <20090717180850.873962925@mini.kroah.org>
 <20090717180923.620590305@mini.kroah.org>
 <200907210139.19672.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907210139.19672.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 01:39:19AM +0200, Arnd Bergmann wrote:
> On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> > I don't think we really want to be doing a irqsave for this code, but I
> > left it alone to preserve the original codepath.  It should be reviewed
> > later.
> 
> This patch does not preserve the original code path if any of the
> callers has a different irq state from the others. When flags is
> shared, releasing the lock actually sets the irq state to whatever
> another thread was using when failing to acquire the lock while
> it was held.
> 
> The patch of course looks good, but the comment is misleading.

Good point, sorry for the misleading comment.

I'll let Hank work out the details as to if the irqsave mode is needed
or not :)

thanks,

greg k-h
