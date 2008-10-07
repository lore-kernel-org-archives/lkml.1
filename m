Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYJGWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYJGWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJGWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:54:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38852 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYJGWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:54:26 -0400
Date: Tue, 7 Oct 2008 17:54:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081007225424.GA9430@us.ibm.com>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007222726.GA9465@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
> > Unless someone will give an example of how having multiple superblocks
> > sharing inodes is a problem in practice for sysfs and call it good
> > for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
> > code is compiled out.  And it should greatly improve testing of the
> > network namespace to at least have access to sysfs.
> 
> But if the network namespace code is in?  THen we have problems, right?
> And that's the whole point here.
> 
> The fact that you are trying to limit userspace view of in-kernel data
> structures, based on that specific user, is, in my opinion, crazy.
> 
> Why not just keep all users from seeing sysfs, and then have a user
> daemon doing something on top of FUSE if you really want to see this
> kind of stuff.

Well the blocker is really that when you create a new network namespace,
it wants to create a new loopback interface, but
/sys/devices/virtual/net/lo already exists.  That's the same issue with
user namespace when the fair scheduler is enabled, which tries to
re-create /sys/kernel/uids/0.

Otherwise yeah at least for my own uses, containers wouldn't need to
look at /sys at all.

Heck you wouldn't even need FUSE, just mount -t tmpfs /sys/class/net
and manually link the right devices from /sys/devices/virtual/net.

-serge
