Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXK0RCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXK0RCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXK0RCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:02:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbXK0RCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:02:24 -0500
Date: Tue, 27 Nov 2007 09:01:47 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
Message-ID: <20071127170147.GB29109@kroah.com>
References: <20071126145810.eb848f23.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0711262124090.22315-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711262124090.22315-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 09:29:36PM -0500, Alan Stern wrote:
> On Mon, 26 Nov 2007, Andrew Morton wrote:
> 
> > On Mon, 19 Nov 2007 10:53:40 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > This patch (as1015) reverts changes that were made to the driver core
> > > about four years ago.  The intent back then was to avoid certain kinds
> > > of invalid memory accesses by leaving kernel objects allocated as long
> > > as any of their children were still allocated.  The original and
> > > correct approach was to wait only as long as any children were still
> > > _registered_; that's what this patch reinstates.
> > 
> > What happened with this?
> 
> As far as I know, it's on Greg's queue.

Yes, it's in my queue still.  Kay and Alan want the patch as it fixes
the new /sys/block -> /sys/class/block patches.  When I add that one
back to my tree (Kay has debugged your old G5 problem now), I'll either
add this patch too, or figure out why it should not be needed.

For now, I'd recommend dropping it from your tree Andrew, as it might
cause odd issues on device removal (not quite sure though...)

thanks,

greg k-h
