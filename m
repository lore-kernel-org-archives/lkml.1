Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZEZVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZEZVCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZEZVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:02:48 -0400
Received: from kroah.org ([198.145.64.141]:34028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZEZVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:02:48 -0400
Date: Tue, 26 May 2009 13:54:14 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name
	to mount debugfs filesystem.
Message-ID: <20090526205414.GA26016@kroah.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:44:49PM -0400, Steven Rostedt wrote:
> 
> On Tue, 26 May 2009, GeunSik Lim wrote:
> 
> > 
> > 
> >  Hi all, 
> >    
> >  I want to hear your opinions about this proposal for consistency of
> >  mount directory to mount debugfs filesystem that need  by ftrace infrastructure.
> >  Um... I appended "RFC" word in the subject because this mail is my proposal just.  
> > 
> > 
> > commit 1766a83645706100b1829bb422f852ec757c6f4b
> > Author: GeunSik,Lim <leemgs1@gmail.com>
> > Date:   Tue May 26 13:49:23 2009 +0900
> > 
> >     Fix terminology inconsistency of dir name to mount debugfs filesystem.
> >     
> >       Many developers use "/debug/" directory name to mount debugfs filesystem
> >       for ftrace according to ./Documentation/tracers/ftrace.txt file.
> >     
> >       But, two directory names(ex:/debug/, /debugfs/) is existed in kernel source
> >       like ftrace, DRM, Wireless, Network[sky2]files to mount debugfs filesystem.
> >       I think that we don't have to select either "/debug/" directory name or
> >       "/debugfs/" directory name for terminology consistency.
> >     
> >       debugfs means debug filesystem for debugging easy to use by greg kroah
> >       hartman. "/debug/" name is suitable as directory name of debugfs for
> >       tracing using ftrace like "/sys/" of sysfs(system filesystem).
> >       -debugfs related reference: http://lwn.net/Articles/115405/
> >     
> >       Fix inconsistency of directory name according to duplicated expression
> >       to mount debugfs.
> >     
> >          Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> 
> I'm guilty of using both /debug and /debugfs in comments. In practice, I 
> only use /debug.
> 
> But...
> 
> The filesystem Nazi's out there will argue that the proper place to mount 
> the debugfs filesystem is /sys/kernel/debug. I personally find that 
> location annoying.

Why?

When I created debugfs, I was told that I had to pick a place to mount
it so that everyone could write scripts that "knew" where it would be.

So we picked /sys/kernel/debug/ and the code creates the mount point to
put it there.  Now distros actually mount debugfs at that location.

So, now you don't like this?  After it's become a standard?  Ick.

Becides, /debug/ is pretty presumptious, it's as if debugging the kernel
is a system-wide thing :)

So please, don't use /debug/ use the standard, defined, and ACTUALLY
USED BY DISTROS TODAY mount point of /sys/kernel/debug/

If you want to create your own symlink from /debug/ to that location to
make it easier to type, feel free, but do not hard code any scripts to
use that location, or they are going to break.

thanks,

greg k-h
