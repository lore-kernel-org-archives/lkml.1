Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040Ab0AEQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab0AEQVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008Ab0AEQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:21:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab0AEQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:21:08 -0500
Date: Tue, 5 Jan 2010 17:21:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/12] SYSFS: Add sysfs_add/remove_files utility
	functions
Message-ID: <20100105162106.GE1778@basil.fritz.box>
References: <201001051247.104464547@firstfloor.org> <20100105114801.7F8B5B17C2@basil.firstfloor.org> <20100105145309.GD11732@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105145309.GD11732@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 06:53:09AM -0800, Greg KH wrote:
> On Tue, Jan 05, 2010 at 12:48:01PM +0100, Andi Kleen wrote:
> > 
> > Adding/Removing a whole array of attributes is very common. Add a standard
> > utility function to do this with a simple function call, instead of
> > requiring drivers to open code this.
> 
> Hm, that is what the sysfs_create_group(), sysfs_update_group(), and
> sysfs_remove_group() functions are for.  We don't need to add any new
> functions that do the same thing, right?

Hmm, originally I didn't use them because they created a sub-directory,
but I see now that's optional.

Still the input format is completely different and doesn't fit into
the ->attrs list that are used elsewhere (e.g. for the sysdev_classes)
So using groups would need a lot of restructuring.

Also similar code as I have is already in a lot of places, which
over time will be converted. So it's definitely less code than
before.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
