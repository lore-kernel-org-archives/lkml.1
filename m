Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbZLQBBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbZLQBBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763530AbZLQBBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:01:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:52277 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763499AbZLQBBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:01:11 -0500
Date: Wed, 16 Dec 2009 17:00:41 -0800
From: Greg KH <gregkh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: devtmpfs [censored] oddities
Message-ID: <20091217010041.GA6479@suse.de>
References: <20091216080431.GF14381@ZenIV.linux.org.uk>
 <20091217003922.GB4863@suse.de>
 <20091217004643.GR14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217004643.GR14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:46:43AM +0000, Al Viro wrote:
> On Wed, Dec 16, 2009 at 04:39:22PM -0800, Greg KH wrote:
> > On Wed, Dec 16, 2009 at 08:04:31AM +0000, Al Viro wrote:
> > > 	May I respectfully suggest that a blocking operation (such as
> > > kstrdup with GFP_KERNEL, or grabbing a mutex, or, say it, pathname resolution)
> > > is not quite the thing to do while holding an rwlock?
> > > 
> > > 	As it is, any device_add() is an embarrassingly obvious deadlock
> > > waiting to happen...
> > 
> > Thomas has posted a patch to fix this now.
> > 
> > Sorry for not catching it sooner, we should just delete the rwlocks so
> > no one tries to ever use it again.
> 
> Say again?  Why would we delete rwlocks?

Sorry, no _new_ use of rwlocks should be added, generally they are used
incorrectly, like this one was.

thanks,

greg k-h
