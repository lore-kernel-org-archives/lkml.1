Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYKNATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYKNATT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYKNATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:19:04 -0500
Received: from kroah.org ([198.145.64.141]:58866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752768AbYKNATC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:19:02 -0500
Date: Thu, 13 Nov 2008 16:18:18 -0800
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Store the relevant miscdevice in file->private_data in
	misc_open()
Message-ID: <20081114001818.GB20023@kroah.com>
References: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au> <20081113173127.GB30811@kroah.com> <1226620481.8066.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226620481.8066.18.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:54:41AM +1100, Michael Ellerman wrote:
> On Thu, 2008-11-13 at 09:31 -0800, Greg KH wrote: 
> > On Thu, Nov 13, 2008 at 03:49:50PM +1100, Michael Ellerman wrote:
> > > Currently it's not easy to share file_operations between multiple
> > > instances of a miscdevice. In order to do this, the device code needs to
> > > store a list of all it's miscdevice instances, and when fops->open() is
> > > called, search the list and find the right device based on the minor
> > > number.
> > > 
> > > However the generic miscdevice code already has a list of miscdevices,
> > > and uses this to find the right device in misc_open(). If misc_open()
> > > would store the miscdevice it found in file->private_data, then the
> > > device code wouldn't need to worry about storing it's own separate list
> > > and searching that as well.
> > > 
> > > The rest of the miscdevice code does not use file->private_data, so the
> > > device code is still free to use file->private_data for something else
> > > if it wants to.
> > > 
> > > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > 
> > Do you have a follow-on patch for some misc device using code that would
> > take advantage of this change?
> 
> Ah, good point. I do, but not for upstream :/

Hm, then I have to ask why should we take this change?

And why would the driver not be availble for upstream to take?

thanks,

greg k-h
