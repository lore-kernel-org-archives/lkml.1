Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYJGETG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYJGETG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJGESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:18:55 -0400
Received: from kroah.org ([198.145.64.141]:38023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750748AbYJGESz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:18:55 -0400
Date: Mon, 6 Oct 2008 21:13:49 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/76] tty: usb-serial krefs
Message-ID: <20081007041349.GB1626@kroah.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161056.1997.12765.stgit@localhost.localdomain> <20081006053658.GA26817@kroah.com> <20081006090246.GC29528@shell.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006090246.GC29528@shell.devel.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 05:02:46AM -0400, Alan Cox wrote:
> On Sun, Oct 05, 2008 at 10:36:58PM -0700, Greg KH wrote:
> > Should we be calling kref_get() and kref_put() in interrupt context?
> > Could we just get the reference in open and then put in close when we
> > are done with it for each driver?
> 
> That depends how you handle hangups and interrupt synchronization. If you
> can be sure you will get no more interrupts before you drop the reference
> in close/hangup then yes that should be fine. In particular watch out for
> the fact that hangup/close/re-open can run pretty much in parallel with
> cases like
> 
> 		close called by user
> 		interrupted by carrier drop causing hangup
> 
> 		in parallel another open begins and blocks waiting a close
> 
> (Obviously for hotplug some further care is needed on the unplug paths)
> 
> Right now USB serial doesn't actually address all those cases anyway I suspect.
> I wasn't going to attack that until I had a common tty_port and tty_port code
> to do all that work rather than trying to fix each group of drivers.

Ok, fair enough, we can do further refinement later.  All of these
changes look great to me, thanks for doing them.  Feel free to put a:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
on the usb-serial ones if you want it.

thanks,

greg k-h
