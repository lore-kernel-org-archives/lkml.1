Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbXFVHhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbXFVHhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXFVHhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:37:46 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42849 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXFVHhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:37:45 -0400
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
	through other means
From: Ram Pai <linuxram@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <467B7509.8010106@zytor.com>
References: <467994BD.6000403@zytor.com>
	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>
	 <1182442837.3342.13.camel@ram.us.ibm.com>  <467AB5EE.3030909@zytor.com>
	 <1182494654.2812.22.camel@ram.us.ibm.com>  <467B7509.8010106@zytor.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 00:34:50 -0700
Message-Id: <1182497690.2812.54.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 00:06 -0700, H. Peter Anvin wrote:
> Ram Pai wrote:
> > 
> > the second patch made a /proc/propagation interface which had almost the
> > same fields, but also added fields to show the propagation type of the
> > mount as well as pointers to its peers and master depending on the type
> > of the mount. 
> > 
> > I think the consensus seems to have a new interface /proc/make-a-name
> > which extends the interface provided by /proc/mounts but provides the
> > propagation state of the mounts too as well as disambiguate bind mounts.
> > Which makes sense.
> > 
> 
> Why?  It seems a lot cleaner to have all the information in the same
> place.  It is highly unfriendly to userspace to have to gather
> information in a lot of places, plus it adds race conditions.
> 
> It would be another matter if the format that we have now couldn't be
> extended, but we need those fields (well, except the two zeros, but who
> cares) *anyway*, so we might as well stick to the existing file, and
> reduce the total amount of code and clutter.

Ok. so you think /proc/mounts can be extended easily without breaking
any userspace commands?

well lets see..
1. to disambiguate bind mounts, we have to add a field that displays the
	 path to the mount's root dentry from the filesystem's root
	 dentry. Agree?

2. For filesystems that do not have a backing store, it becomes hard
	to disambiguate bind mounts in (1). So we need to add a
	filesystem-id field.

3. if we need to add the propagation status of the mount we need a
	 propagation flag added in the output.

4. To be able to construct the propagation tree, we need a way to refer
	to the other mounts, since some mounts are peers and some other
	mounts are master. Which means we need a mount-id field.
	Agree?

If you agree to the above 4 new fields, it becomes challenging to
extend /proc/mounts to incorporate these new fields without
breaking any existing applications. 


> > 
> > BTW: what is the need for overmounted flag?  Do you mean two vfsmounts
> > mounted on the same dentry on the ***same vfsmount*** ?
> > 
> 
> Maybe I'm not following the uses of your flags well enough to figure out
>  if that information can already been deduced.

With the addition of the above 4 mentioned fields, I think one should be
easily able to decipher which mnt-id is mounted on which mnt-id. no?
maybe not. Well we will have to extend the mountpoint field to indicate
the mnt-id in which the mountpoint resides.  

RP

> 
> 	-hpa

