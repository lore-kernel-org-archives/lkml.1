Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753416AbYLQXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYLQXFb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYLQXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:05:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbYLQXFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:05:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: driver probe error reporting
Date: Thu, 18 Dec 2008 00:05:00 +0100
User-Agent: KMail/1.9.9
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
References: <20081215231502.GC12431@fluff.org.uk> <200812172244.35042.rjw@sisk.pl> <20081217215320.GA28033@kroah.com>
In-Reply-To: <20081217215320.GA28033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812180005.01005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 17 of December 2008, Greg KH wrote:
> On Wed, Dec 17, 2008 at 10:44:34PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 17 of December 2008, Greg KH wrote:
> > > On Wed, Dec 17, 2008 at 01:44:52PM +0100, Rafael J. Wysocki wrote:
> > > > On Wednesday, 17 of December 2008, Greg KH wrote:
> > > > > On Mon, Dec 15, 2008 at 11:15:02PM +0000, Ben Dooks wrote:
> > > > > > This runs on from the discussion in [1] on how drivers (especially
> > > > > > one using a variant of the device driver framework) report errors
> > > > > > on probe. There are two main classes of errors, the type which happen
> > > > > > at probe time (device not responding, not enough memory, etc) and
> > > > > > errors that are due to configuration such as missing device configuration
> > > > > > data.
> > > > > > 
> > > > > > It has been suggested that using dev_err() to report any configuration
> > > > > > data error is a bloat of code as a properly debugged kernel should never
> > > > > > find itself in this state.
> > > > > > 
> > > > > > Unfortunatley the only diagnostic dev_xxx() macro is dev_dbg() which is
> > > > > > only available if the the driver code itself defines DEBUG. I would think
> > > > > > it would be better to have a macro that can be turned on/off by a kernel
> > > > > > configuration for when debugging which turns on the messages that are
> > > > > > important to developers creating new machine/arch support but disabled
> > > > > > for shipping kernels.
> > > > > 
> > > > > Not anymore, dev_dbg() can be dynamically switched on and off at runtime
> > > > > in 2.6.28.
> > > > 
> > > > IMO, there's a problem with that, because it turns on _all_ of the debug info
> > > > from the entire kernel, which is _never_ necessary.
> > > 
> > > No, it is turned on and off on a per-module basis, not for the whole
> > > kernel (although that is possible if you so desire.)
> > > 
> > > So this should not be an issue.
> > 
> > Well, recently I've been debugging suspend-resume quite a lot and I had to
> > compile it out.  I use verbose PM debugging for that, which is based on
> > dev_dbg(), and it is very inconvenient with dynamic printk.
> 
> I'm confused, if you enable dynamic printk, it uses dev_dbg().  And then
> you can turn it on or off on a per-module basis.
> 
> What are you suggesting we do instead?

For suspend-resume debugging I need dev_dbg() to work for all devices,
but only in a couple of specific code paths.

Well, I probably could enable it right before suspend and disable right after
the resume.  I'll try that and see if I can filter the noise out this way.

Thanks,
Rafael
