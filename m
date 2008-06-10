Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYFJVfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYFJVfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbYFJVfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:35:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbYFJVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:35:10 -0400
Date: Tue, 10 Jun 2008 14:30:45 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] USB: don't use reset-resume if drivers don't support it
Message-ID: <20080610213045.GD26249@kroah.com>
References: <alpine.LFD.1.10.0806100933060.3101@woody.linux-foundation.org> <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 02:59:43PM -0400, Alan Stern wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> This patch tries to identify which devices are able to accept
> reset-resume handling, by checking that there is at least one
> interface driver bound and that all of the drivers have a reset_resume
> method defined.  If these conditions don't hold then during resume
> processing, the device is logicall disconnected.
> 
> This is only a temporary fix.  Later on we will explicitly unbind
> drivers that can't handle reset-resumes.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Greg:
> 
> This patch really is a temporary fix meant only for 2.6.26.  There
> already are changes in the gregkh development tree which clash with
> this, and I intend to submit separately a real fix for the problem
> (i.e., unbind drivers that don't have suspend, resume, reset_resume,
> pre_reset, or post_reset methods, as needed).
> 
> Is there any way this can be added to 2.6.26-rc while leaving it out of 
> the gregkh tree?

Yes I can, but note, the gregkh tree gets rebased on what goes into -rc,
so hopefully it will not conflict too much :)

thanks,

greg k-h
