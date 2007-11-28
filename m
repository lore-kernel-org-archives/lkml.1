Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXK1Vqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXK1Vqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXK1Vqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:46:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34048 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbXK1Vql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:46:41 -0500
Date: Wed, 28 Nov 2007 13:45:02 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
Message-ID: <20071128214502.GA3255@kroah.com>
References: <1196279172.3242.119.camel@lov.site> <Pine.LNX.4.44L0.0711281532150.2729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711281532150.2729-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 03:42:00PM -0500, Alan Stern wrote:
> This patch (as1020) adds a check to kobject_init() to insure that the
> ktype field is not NULL.  This is just for safety's sake; as far as I
> know there are no remaining places where the field is left unset.  But
> ironically, kset_init() did fail to set it!  The patch fixes that and
> removes some redundant initialization in kset_createa().
> 
> The patch also fixes up elevator_init(), where ktype was set after
> calling kobject_init() instead of before.

No, it's safe to set ktype after kobject_init, it was just not safe to
set the kset.  As Kay pointed out, I just added a patch to my tree to
resolve this issue, and I'll go back and update the documentation now.

I do like the "check for a ktype" warning, I'll go add that to my local
tree and see what breaks.  Odds are, all the static kobjects will :(

thanks,

greg k-h
