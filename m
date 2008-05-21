Return-Path: <linux-kernel-owner+w=401wt.eu-S936833AbYEUSyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936833AbYEUSyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936687AbYEUSxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:53:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936405AbYEUSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:53:10 -0400
Date: Wed, 21 May 2008 14:52:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       systemtap@sources.redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] usb-storage: don't call utsname()
Message-ID: <20080521185251.GA783@infradead.org>
References: <20080521123700.GA8770@infradead.org> <Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org> <20080521180957.GA17598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521180957.GA17598@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 11:09:57AM -0700, Greg KH wrote:
> Why?  With this change, if you change the version number, the file will
> have to be rebuilt.  Without the change, the file will not need to be
> rebuilt, right?

Because thanks to the container patches it utsname fields other than
hostname can actually change at runtime now and you'll get races looking
at them.  And probably not the output you want if someone in your
container changes the kernel version to trick applications.
