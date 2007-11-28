Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXK1RYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXK1RYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbXK1RYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:24:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761343AbXK1RYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:24:42 -0500
Date: Wed, 28 Nov 2007 09:06:54 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128170654.GA29466@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com> <1196253354.3242.40.camel@lov.site> <20071128165205.30ef426f@gondolin.boeblingen.de.ibm.com> <1196265787.3242.65.camel@lov.site> <20071128170950.29c8c7e7@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128170950.29c8c7e7@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 05:09:50PM +0100, Cornelia Huck wrote:
> On Wed, 28 Nov 2007 17:03:07 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Wed, 2007-11-28 at 16:52 +0100, Cornelia Huck wrote:
> > > On Wed, 28 Nov 2007 13:35:54 +0100,
> > > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > 
> > > > On Wed, 2007-11-28 at 10:01 +0100, Cornelia Huck wrote:
> > > > > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> > > > 
> > > > > > Among other things, kobject_init() sets the kobject's reference count to
> > > > > > one.  Calling kobject_init() is not sufficient, however. Kobject users
> > > > > > must, at a minimum, set the name of the kobject; this is the name that will
> > > > > > be used in sysfs entries. 
> > > > > 
> > > > > Unless they don't register their kobject. (But they should always set a
> > > > > name anyway to avoid funny debug messages, so it is probably a good
> > > > > idea to call this a "must").
> > > > 
> > > > Yeah, we should require it. And kobject_cleanup() needs to be called to
> > > > free the allocated name, if the object is not already added and needs to
> > > > be deleted (common in rewinding on error).
> > > 
> > > Always using kobject_put() should take care of that.
> > 
> > Ok, so we can always require a kobject_put() after a kobject_init(), to
> > cleanup what happened after _init() and before _add()?
> 
> That's a sensible requirement, I think.

Yes, there are a few usages of unregistered kobjects in the kernel
today, but I think that was people just not realizing they could use a
simple kref instead.  I'm working on cleaning them up right now...

thanks,

greg k-h
