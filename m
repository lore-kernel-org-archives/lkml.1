Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYH1RlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYH1RlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYH1RlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:41:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYH1RlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:41:07 -0400
Date: Thu, 28 Aug 2008 10:33:01 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
Message-ID: <20080828173301.GB18097@kroah.com>
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org> <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6D9B7.2050406@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 07:00:39PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> > On Thu, Aug 28, 2008 at 06:31:02PM +0200, Tejun Heo wrote:
> >> add_uevent_var() appends the specified variable whether the new entry
> >> has duplicate key or not.  This patch makes add_uevent_var() to
> >> override the existing entry if an entry with the same key is added
> >> later.  This will be used by CUSE (character device in userland) to
> >> fake hotplug events.
> > 
> > Hm, do you have any pointers to CUSE, that sounds interesting.
> 
> I'm in the process of sending patches.  I'll cc you on the actual postings.

Thanks, I'd appreciate that.

> > And how would this change interact with fake hotplug events?
> 
> CUSE creates actual devices but those devices are all cuse class
> devices.  To play nicely with sysfs/hal, the ADD/REMOVE uevents should
> have about the same variables as the actual device including the
> SUBSYSTEM, so that's where the overriding comes in.  CUSE client tells
> CUSE that it needs to set such such envs for uevents and CUSE overrides
> uevents before sending it out so that sysfs/hal can be fooled.

Heh, nice, sounds interesting.  I'll queue this patch up.

thanks,

greg k-h
