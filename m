Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXDVHvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXDVHvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXDVHvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:51:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59115 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483AbXDVHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:51:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 3/8] account user mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102631.544911966@szeredi.hu>
	<m1odlhkfvy.fsf@ebiederm.dsl.xmission.com>
	<E1HfWDh-00046V-00@dorka.pomaz.szeredi.hu>
Date: Sun, 22 Apr 2007 01:49:22 -0600
In-Reply-To: <E1HfWDh-00046V-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Sun, 22 Apr 2007 09:10:49 +0200")
Message-ID: <m1lkgk26il.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> > From: Miklos Szeredi <mszeredi@suse.cz>
>> >
>> > Add sysctl variables for accounting and limiting the number of user
>> > mounts.
>> >
>> > The maximum number of user mounts is set to 1024 by default.  This
>> > won't in itself enable user mounts, setting a mount to be owned by a
>> > user is first needed
>> 
>> Since each mount has a user can we just make this a per user rlimit?
>> 
>> If we are going to implement a sysctl at this point I think it should
>> be a global limit that doesn't care if who you are.  Even root can
>> have recursive mounts that attempt to get out of control.
>
> Recursive bind mounts are done carefully enough, so they don't get out
> of control.
>
> Recursive mount propagations can get out of control.  But root can
> shoot itself in the foot any number of ways, and it's not for the
> kernel to police that.

Yes.  It is.

This is mostly about removing special cases.

We routinely have limits on resources that are global and apply
to root along with every one else.  Root can change them but
they still apply to root.  Things like the number of inodes
in the system or the total number of files.

Since it is perfectly possible to do a per user rlimit at this stage
in the design.  I contend that either:
- We implement a per user rlimit of mounts.
- We implement a global limit on mounts.

No other case makes sense.  The previous objections were at least in
part because the limit only applied to user mounts but the name of
the limit did not apply to user mounts.


>> Also currently you are not checking the max_users.  It looks like
>> you do this in a later patch but still it is a little strange to
>> allow user own mounts and have accounting but to not check the
>> limit at this state.
>
> Yeah, but at this stage user mounts are not yet allowed, so this is
> safe.

Eric
