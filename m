Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXK3VI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXK3VI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXK3VIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:08:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33146 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbXK3VIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:08:14 -0500
Date: Fri, 30 Nov 2007 13:07:19 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071130210719.GA6924@kroah.com>
References: <20071130195300.GB4659@kroah.com> <Pine.LNX.4.44L0.0711301513390.2941-100000@iolanthe.rowland.org> <20071130210420.GA6097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130210420.GA6097@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 01:04:20PM -0800, Greg KH wrote:
> > My suggestion: Have kobject_init_ng() accept a ktype pointer but not a 
> > parent or name.  Instead, make kobject_add_ng() take the parent and 
> > name (possibly a kset also).  Then when kobject_init_and_add() 
> > encounters an error, it shouldn't do a _put() -- the caller can either 
> > do the _put() or just do a kfree().
> 
> Why not the parent for init()?  Isn't it always known at that time?
> I'll dig to be sure.

You are right again, to match up with the driver core methods, we don't
know the parent until add() time.

thanks,

greg k-h
