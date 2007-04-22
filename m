Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXDVIPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXDVIPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXDVIPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:15:48 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:57487 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXDVIPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:15:46 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1lkgk26il.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 3/8] account user mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102631.544911966@szeredi.hu>
	<m1odlhkfvy.fsf@ebiederm.dsl.xmission.com>
	<E1HfWDh-00046V-00@dorka.pomaz.szeredi.hu> <m1lkgk26il.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfX7p-0004HU-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 10:08:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > From: Miklos Szeredi <mszeredi@suse.cz>
> >> >
> >> > Add sysctl variables for accounting and limiting the number of user
> >> > mounts.
> >> >
> >> > The maximum number of user mounts is set to 1024 by default.  This
> >> > won't in itself enable user mounts, setting a mount to be owned by a
> >> > user is first needed
> >> 
> >> Since each mount has a user can we just make this a per user rlimit?
> >> 
> >> If we are going to implement a sysctl at this point I think it should
> >> be a global limit that doesn't care if who you are.  Even root can
> >> have recursive mounts that attempt to get out of control.
> >
> > Recursive bind mounts are done carefully enough, so they don't get out
> > of control.
> >
> > Recursive mount propagations can get out of control.  But root can
> > shoot itself in the foot any number of ways, and it's not for the
> > kernel to police that.
> 
> Yes.  It is.
> 
> This is mostly about removing special cases.
> 
> We routinely have limits on resources that are global and apply
> to root along with every one else.  Root can change them but
> they still apply to root.  Things like the number of inodes
> in the system or the total number of files.

There's no max_inodes any more.  As for max_files:

get_empty_filp():

	/*
	 * Privileged users can go above max_files
	 */
	if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {

Miklos
