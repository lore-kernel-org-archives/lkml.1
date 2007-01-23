Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXAWBTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXAWBTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXAWBTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:19:42 -0500
Received: from agminet02.oracle.com ([141.146.126.229]:23723 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXAWBTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:19:41 -0500
Date: Mon, 22 Jan 2007 17:13:16 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: configfs: return value for drop_item()/make_item()?
Message-ID: <20070123011316.GC9422@ca-server1.us.oracle.com>
Mail-Followup-To: Michael Noisternig <mnoist@cosy.sbg.ac.at>,
	linux-kernel@vger.kernel.org
References: <45AF6D0C.8020600@cosy.sbg.ac.at> <20070118221249.GO27360@ca-server1.us.oracle.com> <45B4AF98.2080407@cosy.sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B4AF98.2080407@cosy.sbg.ac.at>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 01:35:36PM +0100, Michael Noisternig wrote:
> Sure, but what I meant to say was that the user, when creating a 
> directory, did not request creation of such sub-directories, so I see 
> them as created by the kernel.

	Ahh, but userspace did!  It's part of the configfs contract.
They've asked for an new config item and all that it entails.

> If you argue that they are in fact created by the user because they are 
> a direct result of a user action, then I can apply the same argument to 
> this one example:
> ...
> >This is precisely what configfs is designed to forbid. The kernel
> >does not, ever, create configfs objects on its own. It does it as a
> >result of userspace action.
> 
> No. The sub-directory only appears as a direct result of the user 
> writing a value into the 'type' attribute. ;-)

	Ok, you're stretching the metaphor.  Writing a value to a "type"
attribute is, indeed, a userspace action.  However, configfs' contract
is that only mkdir(2) creates objects.
	We're not trying to create the do-everything-kitchen-sink system
here.  That way lies the problems we're trying to avoid.  That's why
configfs has a specific contract it provides to (a) userspace and (b)
client drivers.

> >you're never going to get it from configfs. You should be using
> >sysfs.
> 
> Hardly. sysfs doesn't allow the user creating directories. :>

	sysfs certainly supports your "echo b > type" style of object
creation.  You're type_file->store() method gets a "b" in the buffer and
then does sysfs_mkdir() of your new object directory.  Here, the kernel
is creating the new object (the directory).

> Well, you don't need PTR_ERR().

	Sure, you could use **new_item.  It's the same complexity
change.
 
> That's an interesting other solution, however it seems a bit redundant 
> (params are referenced by links as well as in the 'order' attribute 
> file) and not as simple as my method 2). I guess, for now, in lack of a 
> convincing solution, I will implement method 2) as the one easiest to 
> adapt to given my current code base.

	But they are not referenced by the order file.  It's just an
attribute :-)  Really, you can look at it either way.  But configfs has
a specific perspective based on its contracts, and so it works within
them.

> Hm, I had envisioned the user to fully configure the module via file 
> system operations only. Now if the user is supposed to use a wrapper 
> program this sheds a different light on all those 
> what's-the-best-solution issues...

	Certainly the user can do the configuration by hand.  It will
always work.  But why make them understand your userspace<->kernel API
when you can just provide a tool?  They're all going to script it up
anyway.

Joel

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
