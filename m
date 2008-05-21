Return-Path: <linux-kernel-owner+w=401wt.eu-S936745AbYEUTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745AbYEUTgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936968AbYEUTfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:35:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55286 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936957AbYEUTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:35:42 -0400
Date: Wed, 21 May 2008 12:35:17 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       systemtap@sources.redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] usb-storage: don't call utsname()
Message-ID: <20080521193517.GA4905@kroah.com>
References: <20080521123700.GA8770@infradead.org> <Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org> <20080521180957.GA17598@kroah.com> <20080521185251.GA783@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521185251.GA783@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 02:52:51PM -0400, Christoph Hellwig wrote:
> On Wed, May 21, 2008 at 11:09:57AM -0700, Greg KH wrote:
> > Why?  With this change, if you change the version number, the file will
> > have to be rebuilt.  Without the change, the file will not need to be
> > rebuilt, right?
> 
> Because thanks to the container patches it utsname fields other than
> hostname can actually change at runtime now and you'll get races looking
> at them.  And probably not the output you want if someone in your
> container changes the kernel version to trick applications.

So, do we now go and rip out all usages of utsname()->release and put
back the #define just because of the loonacy of containers?

No kernel should have to change it's version number to trick an
application, why would an application care about the version number to
start with?  In the "enterprise kernel" world, version numbers have
little to no relevance on the functionality or features of the kernel,
so any check of something like this is sure to be wrong to start with.

thanks,

greg k-h
