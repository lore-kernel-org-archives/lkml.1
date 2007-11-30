Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXK3WeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXK3WeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXK3WeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:34:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXK3Wd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:33:59 -0500
Date: Fri, 30 Nov 2007 14:33:04 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
	functions
Message-ID: <20071130223304.GA7916@kroah.com>
References: <20071130214819.GA7326@kroah.com> <Pine.LNX.4.44L0.0711301702200.2747-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711301702200.2747-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 05:10:33PM -0500, Alan Stern wrote:
> On Fri, 30 Nov 2007, Greg KH wrote:
> 
> > Ok, how about this:
> > 	void kobject_init(struct kobject *kobj, struct ktype *ktype);
> > 
> > and then:
> > 	int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);
> > 
> > After we call kobject_init() we HAVE to call kobject_put() to clean up
> > properly.  So, if kobject_add() fails, we still need to clean up with
> > kobject_put();
> 
> You could put that a little less strongly.  After kobject_init() you
> SHOULD call kobject_put() to clean up properly, and after kobject_add()
> you MUST call kobject_del() and kobject_put().

No, in looking at the code, you only need to call kobject_del() to clean
everything up properly, if kobject_add() succeeds.  No need to call
kobject_put() yet again.

Can someone else verify that this really is correct?

thanks,

greg k-h

p.s. I think it's time to start a "travel to .nz and kick a certain
ex-kernel-developer around a bit" fund...
