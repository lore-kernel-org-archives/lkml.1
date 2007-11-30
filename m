Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXK3T4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXK3T4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXK3T4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:56:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbXK3T43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:56:29 -0500
Date: Fri, 30 Nov 2007 11:51:50 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC] kobject_init changes
Message-ID: <20071130195150.GA4659@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New thread time...

Here are two patches, one that adds a two new functions,
kobject_init_ng() and kobject_init_and_add() and then a patch that shows
how a number of different users are converted over to these new
functions.

I choose the name "kobject_init_ng()" for now, so that I can do a patch
series that converts the differnet usages in the kernel tree, and then
do a global rename all at once, making it easier to find any potential
problems that might happen.

Same goes for the _and_add() function, which is really just
kobject_register() but without the uevent call, and it has proper memory
cleanup.

Any objections to these changes?

My plans with this are:
	- clean up the rest of the kernel tree usages of kobject_init()
	- rename kobject_init_ng() to kobject_init().
	- remove all users of kobject_register() and use the new
	  functions and a uevent call.
	- fix up the new kobject_create_and_register() function to be
	  create_and_add() instead.

The last one will require some patch reworking in my tree, but I have
four days of meetings next week, and two plane rides, so I'll need
something real to do :)

I suppose if I really get bored, I can fix up the cdev stuff, but that's
going to take a lot more work...

thanks,

greg k-h
