Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbXIZPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbXIZPZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXIZPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:24:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46608 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760811AbXIZPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:24:45 -0400
Date: Wed, 26 Sep 2007 08:14:58 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070926151458.GA10460@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com> <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu> <20070926024121.GA28124@kroah.com> <20070926092156.2f281eea@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926092156.2f281eea@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:21:56AM +0200, Cornelia Huck wrote:
> On Tue, 25 Sep 2007 19:41:21 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > Ok, here's a patch that fixes this for me.  It should go on top of the
> > -mm tree.  Let me know of this works or not.
> 
> Looks sane to me.
> 
> > In the end, we need to dynamically allocate these subsystems to properly
> > fix this.  In looking through the tree, there really isn't that many of
> > them, so I'll try to knock that out later this week.
> 
> What they need at least is a dynamically allocated k_name.

Yes :(

> Same goes
> for all those objects that use set_kset_name(), and there are quite a
> few of those...

Almost all of those are the stupid sysdev_class and sys_device stuff.  I
_really_ want to get rid of those as they should be a "normal"
device/driver/class.  I think Adam Belay has some patches he is working
on to get rid of these, but I do not know the status of them.

Anyway, they are static structures, so my fix will keep them from
oopsing.

thanks,

greg k-h
