Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753765AbYLQMp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbYLQMp3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYLQMpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:45:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYLQMpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:45:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: driver probe error reporting
Date: Wed, 17 Dec 2008 13:44:52 +0100
User-Agent: KMail/1.9.9
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
References: <20081215231502.GC12431@fluff.org.uk> <20081217063655.GA12933@kroah.com>
In-Reply-To: <20081217063655.GA12933@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171344.52872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 17 of December 2008, Greg KH wrote:
> On Mon, Dec 15, 2008 at 11:15:02PM +0000, Ben Dooks wrote:
> > This runs on from the discussion in [1] on how drivers (especially
> > one using a variant of the device driver framework) report errors
> > on probe. There are two main classes of errors, the type which happen
> > at probe time (device not responding, not enough memory, etc) and
> > errors that are due to configuration such as missing device configuration
> > data.
> > 
> > It has been suggested that using dev_err() to report any configuration
> > data error is a bloat of code as a properly debugged kernel should never
> > find itself in this state.
> > 
> > Unfortunatley the only diagnostic dev_xxx() macro is dev_dbg() which is
> > only available if the the driver code itself defines DEBUG. I would think
> > it would be better to have a macro that can be turned on/off by a kernel
> > configuration for when debugging which turns on the messages that are
> > important to developers creating new machine/arch support but disabled
> > for shipping kernels.
> 
> Not anymore, dev_dbg() can be dynamically switched on and off at runtime
> in 2.6.28.

IMO, there's a problem with that, because it turns on _all_ of the debug info
from the entire kernel, which is _never_ necessary.  Almost always you need
debug output for specific subsystem, if not for specific driver, and all of the
superfluous debug data resulting from the "dynamic printk" only makes things
harder.

Thanks,
Rafael
