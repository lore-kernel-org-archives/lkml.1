Return-Path: <linux-kernel-owner+w=401wt.eu-S1030803AbXAZGrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030803AbXAZGrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030805AbXAZGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:47:12 -0500
Received: from mail.kroah.org ([69.55.234.183]:54621 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030803AbXAZGrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:47:12 -0500
Date: Thu, 25 Jan 2007 22:47:01 -0800
From: Greg KH <greg@kroah.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Kristian H??gsberg <krh@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Juju
Message-ID: <20070126064701.GA21892@kroah.com>
References: <20070124223745.33278eb4.zaitcev@redhat.com> <45B91EAB.9080004@redhat.com> <20070125153824.8d7f50c5.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125153824.8d7f50c5.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 03:38:24PM -0800, Pete Zaitcev wrote:
> On Thu, 25 Jan 2007 16:18:35 -0500, Kristian H??gsberg <krh@redhat.com> wrote:
> 
> > > I see that ORBs are always allocated with a call (like SKB) and not
> > > embedded into drivers (like URBs). It's great, keep it up. Also,
> > > never allow drivers to pass DMA-mapped buffers into fw_send_request
> > > and friends. We made both of these mistakes in USB, and it hurts.
> > 
> > Oh, the ORBs are SBP-2 specific data structures, struct fw_transaction is 
> > probably what corresponds to USB URBs.  This struct is defined in 
> > fw-transaction.h and is available for embedding into other structs, such as 
> > struct sbp2_orb in fw-sbp2.  Is that what you're suggesting against, and what 
> > are the problems with this approach?
> 
> Fortunately we do not care about out-of-tree drivers, which are most
> affected, you may even call it a feature ^_^. My main problem is,
> we can't refcount URBs, so usbmon can't tap them and must copy.

urbs are reference counted, it's just that not all drivers who create
them use them that way :(

Perhaps you can inforce this in the new codebase...

thanks,

greg k-h
