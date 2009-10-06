Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZJFDGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZJFDGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 23:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZJFDGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 23:06:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbZJFDGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 23:06:17 -0400
Date: Mon, 5 Oct 2009 20:05:13 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Colin Guthrie <cguthrie@mandriva.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: get_device_parent() race bug
Message-ID: <20091006030513.GA24232@kroah.com>
References: <4ABC7DB5.9010402@kernel.org> <4AC7EDD7.3080906@kernel.org> <20091005142201.GA21891@kroah.com> <4ACA9A20.4050809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA9A20.4050809@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 10:15:12AM +0900, Tejun Heo wrote:
> Greg KH wrote:
> >>>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> >> Ping.  This one needs to be fixed in -stable.  It can be triggered by
> >> other char devices too.
> >
> > Sorry, been slowly catching up...
> > 
> > This can be triggered by char devices?  Huh?  How?  I don't see the
> > failure path that is happening here.
> 
> Oooh, s/char/virtual/.  The bug is in the path which creates a
> directory under the phony parent.
> 
> > And char devices shouldn't really be using the kobject at all, except
> > for a very basic reference count.
> > 
> > I keep threatening to rip kobject out of a char device and just use a
> > kref, as that is all that is really needed.  Well, that and the kmap
> > stuff, but again, it's not a "real" kobject being used there...
> > 
> > Perhaps now is the time to do this.
> 
> Yay!

Ugh, I tried to do this today but it looks like the gendisk structure
got all tied up with the kobj_map logic.  Which doesn't look all too
correct to me but I'm not sure.

Kay, you did the gendisk kobject conversion, right?  Any reason you tied
it into the kobj_map stuff?  Or was that the way the code always was?

thanks,

greg k-h
