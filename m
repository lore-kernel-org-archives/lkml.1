Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZK3V6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZK3V6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZK3V6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:58:05 -0500
Received: from kroah.org ([198.145.64.141]:58813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZK3V6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:58:04 -0500
Date: Mon, 30 Nov 2009 13:53:47 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/15] sysfs lazification final
Message-ID: <20091130215347.GA2750@kroah.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
 <m1pr7tmqb4.fsf@fess.ebiederm.org>
 <20091130213337.GA3468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130213337.GA3468@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:33:37PM -0800, Greg KH wrote:
> On Sat, Nov 07, 2009 at 11:25:03PM -0800, Eric W. Biederman wrote:
> > 
> > The sysfs code updates the vfs caches immediately when the sysfs data
> > structures change causing a lot of unnecessary complications.  The
> > following patchset untangles that beast.  Allowing for simpler
> > more straight forward code, the removal of a hack from the vfs
> > to support sysfs, and human comprehensible locking on sysfs.
> > 
> > Most of these patches have already been reviewed and acked from the
> > last time I had time to work on sysfs.
> > 
> > This acks have been folded in and the two small bugs found in the
> > previous review have been fixed in the trailing patches (they are
> > minor enough nits that even a bisect that happens to land in the
> > middle should not see sysfs problems).
> 
> I've applied all of these to my tree now, and sorry, but something is
> broken pretty badly.
> 
> When doing a simple 'ls /sys/class/input/' the process locks up.  This
> means that X can't find any input devices, which makes for a bit of a
> problem when wanting to use your mouse or keyboard :(
> 
> Attached is the state of my processes when this happens, if that helps
> out any.
> 
> So I'm going to drop all of these from my tree again, as they are not
> ready for merging at this point :(

In looking at the stuck processes, it seems your last patch was the
problem.  Removing that caused things to work again, so I've only
dropped that one.

Next time, please test your patches before submitting them :(

thanks,

greg k-h
