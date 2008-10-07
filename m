Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYJGWbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYJGWbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYJGWbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:31:04 -0400
Received: from kroah.org ([198.145.64.141]:43739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbYJGWbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:31:03 -0400
Date: Tue, 7 Oct 2008 15:27:26 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081007222726.GA9465@kroah.com>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpxwajyy.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
> Unless someone will give an example of how having multiple superblocks
> sharing inodes is a problem in practice for sysfs and call it good
> for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
> code is compiled out.  And it should greatly improve testing of the
> network namespace to at least have access to sysfs.

But if the network namespace code is in?  THen we have problems, right?
And that's the whole point here.

The fact that you are trying to limit userspace view of in-kernel data
structures, based on that specific user, is, in my opinion, crazy.

Why not just keep all users from seeing sysfs, and then have a user
daemon doing something on top of FUSE if you really want to see this
kind of stuff.

The "leakage" just seems too hard to stop.

> Later Tejun or I or possibly someone else who cares can go back
> and simplify the sysfs locking to remove the need for multiple
> superblocks sharing inodes, and to address the other big nasties in
> the current sysfs implementation.  

I know how the whole "we'll go back later and fix it up" stuff works,
I've used that excuse too many times in the past myself.  Never happens
:)

> Greg I agree with Al that sysfs isn't perfect but we sure aren't going
> to fix it if you keep dropping or taking years to merge every patch
> from the people working on it, and then dropping those patches because
> someone frowns at them.

"years"?  Come on, these did take a while due to travel and other stuff.
These are core kernel changes, and need time to ensure that they work
properly, and get the proper review from people who understand this kind
of stuff.

And to call Al a generic "someone", is just rude and disrespectful.  I
trust his opinion in this area far more than I do yours, to be honest.

This whole series is dropped, if you want to resubmit them, feel free
to, _after_ adressing his issues.

bah,

greg k-h
