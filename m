Return-Path: <linux-kernel-owner+w=401wt.eu-S937924AbYCSX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937924AbYCSX1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966360AbYCSWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761415AbYCSWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:13 -0400
Date: Wed, 19 Mar 2008 11:07:21 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
Message-ID: <20080319180721.GB5296@kroah.com>
References: <200803170020.55473.rjw@sisk.pl> <200803170022.30345.rjw@sisk.pl> <20080319005340.GC8298@kroah.com> <200803191422.02064.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191422.02064.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:22:00PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Greg KH wrote:
> > On Mon, Mar 17, 2008 at 12:22:29AM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Introduce 'struct pm_ops' representing a set of suspend and
> > > hibernation operations for bus types, device classes and device
> > > types.
> > 
> > Ok, I must have missed the thread describing why we need to do this, so,
> > why do we need to do this?  What is this going to buy us in the end
> > after everything is changed?
> 
> There were many threads related to that.
> 
> To summarize, the first purpose is to separate suspend (aka s2ram and standby)
> callbacks from hibernation callbacks in such a way that the new callbacks won't
> take arguments and the purpose of each of them will be clearly specified.  This
> has been requested multiple times by many people, including Linus himself,
> and the reason is that within the current scheme if ->resume() is called, for
> example, it's difficult to say why it's been called (ie. is it a resume from RAM or
> from hibernation or a suspend/hibernation failure etc.?).
> 
> The second purpose is to make the suspend/hibernation callbacks more flexible
> so that device drivers can handle more than they can within the current scheme.
> For example, some drivers may need to prevent new children of the device from
> being registered before their ->suspend() callbacks are executed or they may
> want to carry out some operations requiring the availability of some other
> devices, not directly bound via the parent-child relationship, in order to prepare
> for the execution of ->suspend(), etc.
> 
> Ultimately, we'd like to stop using the freezing of tasks for suspend and
> therefore the drivers' suspend/hibernation code will have to take care of
> the handling of the user space during suspend/hibernation which would be
> difficult within the current scheme, without the ->prepare() and ->complete()
> callbacks.

Ok, thanks.  You might want to include this in the patch itself (hint,
hint, hint...)

greg k-h
