Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYJGXhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYJGXhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYJGXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:37:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:45652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYJGXh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:37:27 -0400
Message-ID: <48EBF21E.40709@kernel.org>
Date: Wed, 08 Oct 2008 08:34:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com>
In-Reply-To: <20081007222726.GA9465@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 23:36:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Greg KH wrote:
> On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
>> Unless someone will give an example of how having multiple superblocks
>> sharing inodes is a problem in practice for sysfs and call it good
>> for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
>> code is compiled out.  And it should greatly improve testing of the
>> network namespace to at least have access to sysfs.
> 
> But if the network namespace code is in?  THen we have problems, right?
> And that's the whole point here.
> 
> The fact that you are trying to limit userspace view of in-kernel data
> structures, based on that specific user, is, in my opinion, crazy.

Well, that's the whole point of all the namespace stuff.  If we're
gonna do namespaces, view of in-kernel data structures need to be
limited and modified one way or the other.

> Why not just keep all users from seeing sysfs, and then have a user
> daemon doing something on top of FUSE if you really want to see this
> kind of stuff.

That sounds nice.  Out of ignorance, how is the /proc dealt with?
Maybe we can have some unified approach for this multiple views of the
system stuff.

> The "leakage" just seems too hard to stop.
> 
>> Later Tejun or I or possibly someone else who cares can go back
>> and simplify the sysfs locking to remove the need for multiple
>> superblocks sharing inodes, and to address the other big nasties in
>> the current sysfs implementation.  
> 
> I know how the whole "we'll go back later and fix it up" stuff works,
> I've used that excuse too many times in the past myself.  Never happens
> :)

Heh... I've been telling Jeff I would update libata API doc right
after the next big change for about two years now.  :-)

>> Greg I agree with Al that sysfs isn't perfect but we sure aren't going
>> to fix it if you keep dropping or taking years to merge every patch
>> from the people working on it, and then dropping those patches because
>> someone frowns at them.
> 
> "years"?  Come on, these did take a while due to travel and other stuff.
> These are core kernel changes, and need time to ensure that they work
> properly, and get the proper review from people who understand this kind
> of stuff.

Eric has tried hard for quite some time to improve sysfs and get the
namespace stuff merged and it hasn't been a smooth process and mostly
for non-technical reasons at that (his changes crashing with mine and
me being lazy played a big part).  So, now everything seemed to go in
and got dropped again, so I think he has good reasons to get
frustrated, so it would be really nice if we can discuss this with
some civility.

> And to call Al a generic "someone", is just rude and disrespectful.  I
> trust his opinion in this area far more than I do yours, to be honest.

Al's review was very helpful but it wasn't the most respectful one
either.  I understand that's his style and you do too, right?  Then, I
don't think it's fair to call Eric rude and disrepectful for calling
Al a generic "someone".  Let's let that be his style too.

> This whole series is dropped, if you want to resubmit them, feel free
> to, _after_ adressing his issues.

I think the more important thing to discuss is how this namespace
stuff is gonna proceed.  I'm quite ignorant about the issue and one of
the reasons why I acked the changes although I had my reservations was
becuase the namespace approach seemed to have been agreed upon.  Is
it?  Can somebody hammer the big picture regarding namespaces into my
small head?

Thanks.

-- 
tejun
