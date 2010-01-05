Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897Ab0AEXV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0AEXV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648Ab0AEXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:21:58 -0500
Received: from kroah.org ([198.145.64.141]:43550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab0AEXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:21:57 -0500
Date: Tue, 5 Jan 2010 15:20:18 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/12] SYSFS: Add sysfs_add/remove_files utility
 functions
Message-ID: <20100105232018.GA815@kroah.com>
References: <201001051247.104464547@firstfloor.org>
 <20100105114801.7F8B5B17C2@basil.firstfloor.org>
 <20100105145309.GD11732@kroah.com>
 <20100105162106.GE1778@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105162106.GE1778@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:21:06PM +0100, Andi Kleen wrote:
> On Tue, Jan 05, 2010 at 06:53:09AM -0800, Greg KH wrote:
> > On Tue, Jan 05, 2010 at 12:48:01PM +0100, Andi Kleen wrote:
> > > 
> > > Adding/Removing a whole array of attributes is very common. Add a standard
> > > utility function to do this with a simple function call, instead of
> > > requiring drivers to open code this.
> > 
> > Hm, that is what the sysfs_create_group(), sysfs_update_group(), and
> > sysfs_remove_group() functions are for.  We don't need to add any new
> > functions that do the same thing, right?
> 
> Hmm, originally I didn't use them because they created a sub-directory,
> but I see now that's optional.
> 
> Still the input format is completely different and doesn't fit into
> the ->attrs list that are used elsewhere (e.g. for the sysdev_classes)
> So using groups would need a lot of restructuring.

Argh, you are right.

Damm I hate the sysdev code, I need to dig up my "make drivers bind to
multiple devices" tree and get it up to date so we can just delete the
things completly and move to a "real" struct device instead.

> Also similar code as I have is already in a lot of places, which
> over time will be converted. So it's definitely less code than
> before.

Ok, good point, I'll queue this up, and hopefully be able to delete it
all in 6-8 months again :)

thanks,

greg k-h
