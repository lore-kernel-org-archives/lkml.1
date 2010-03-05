Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0CEEnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:43:10 -0500
Received: from THUNK.ORG ([69.25.196.29]:50117 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab0CEEnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:43:06 -0500
Date: Thu, 4 Mar 2010 23:43:05 -0500
From: tytso@mit.edu
To: linux-kernel@vger.kernel.org, lvm-devel@redhat.com
Subject: Re: [2.6.33 REGRESSION BUG] Can't boot lvm on root (Ubuntu 9.10
 userspace) with 2.6.33
Message-ID: <20100305044305.GC5747@thunk.org>
Mail-Followup-To: tytso@mit.edu, linux-kernel@vger.kernel.org,
	lvm-devel@redhat.com
References: <E1Nmppq-0000sA-E1@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Nmppq-0000sA-E1@closure.thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 09:46:02AM -0500, Theodore Ts'o wrote:
> 
> The last kernel I could boot was 2.6.33-rc4, so this might be a
> regression.   As near as I can tell, this udev rule isn't firing:
> 
> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="lvm*|LVM*", \
> 	RUN+="watershed sh -c '/sbin/lvm vgscan; /sbin/lvm vgchange -a y'"
> 
> So nothing is showing up in /dev/mapper, and so the root can't be
> mounted.  After 45 seconds, it drops me into the initramfs shell, and if
> I manually run "lvm vgscan" and "lvm vgscange -ay", everything is back,
> but then I can't figure out how to restart the boot process from inside
> a failed initramfs.   And of course, the initramfs environment is so
> crappy that there are no debugging aids --- not even a working pager.
> 
> Did I mention how much I hate the whole initramfs with dynamic udev
> rules as a design?

So the workaround I've found for this is to use the magic boot command
line option: 

     break=premount

And then at the initramfs prompt, enter the command "lvm2 vgchange
-ay", followed by control-D.  

Then you'll run into the hal/X11 regression, where I've documented the
workaround I had to use for that.

So I can at least test during the merge window, but it would be nice
if these regressions could get fixed in a real way.

   	 	      	    	      	   - Ted
