Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXDVHLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXDVHLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXDVHLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:11:49 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58535 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXDVHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:11:47 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1odlhkfvy.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 3/8] account user mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102631.544911966@szeredi.hu> <m1odlhkfvy.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfWDh-00046V-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 09:10:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Add sysctl variables for accounting and limiting the number of user
> > mounts.
> >
> > The maximum number of user mounts is set to 1024 by default.  This
> > won't in itself enable user mounts, setting a mount to be owned by a
> > user is first needed
> 
> Since each mount has a user can we just make this a per user rlimit?
> 
> If we are going to implement a sysctl at this point I think it should
> be a global limit that doesn't care if who you are.  Even root can
> have recursive mounts that attempt to get out of control.

Recursive bind mounts are done carefully enough, so they don't get out
of control.

Recursive mount propagations can get out of control.  But root can
shoot itself in the foot any number of ways, and it's not for the
kernel to police that.

> Also currently you are not checking the max_users.  It looks like
> you do this in a later patch but still it is a little strange to
> allow user own mounts and have accounting but to not check the
> limit at this state.

Yeah, but at this stage user mounts are not yet allowed, so this is
safe.

Miklos
