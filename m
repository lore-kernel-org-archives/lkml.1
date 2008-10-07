Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYJGXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYJGXUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYJGXUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:20:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:51298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbYJGXUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:20:41 -0400
Message-ID: <48EBEE0B.6080009@kernel.org>
Date: Wed, 08 Oct 2008 08:17:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>	<20081003101331.GH28946@ZenIV.linux.org.uk>	<48EB27FE.2090009@kernel.org> <m1zllgzki0.fsf@frodo.ebiederm.org> <48EB53B8.5020309@kernel.org>
In-Reply-To: <48EB53B8.5020309@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 23:19:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, a bit of additions after some sleep.

Tejun Heo wrote:
> Eric W. Biederman wrote:
> IIRC, the original readdir implementation put a cursor entry to walk
> through the children list.  The implementation was horribly broken in
> a number of different ways (ISTR problems with locking and multiple
> and different type of walkers) and I just gutted out all the
> complexity out and made it simple as getting it correct was far more
> important and there seemed to be little need for optimization.
> 
> Yeah, using RCU sounds like a plan.

Heh... it did sound like a plan but I don't think the plan would solve
the problem.  filldir can't be put in rcu read critical section.  :-p

>> The revalidate on access model doesn't appear to have a way to track
>> remote renames.  Something sysfs supports.
> 
> Yeap, IIRC, one of the reasons why sysfs wasn't converted over to
> sysfs was because sysfs guarantees inode doesn't change over rename or
> move so that notifications keep working over renames.

s/over to sysfs/over to revalidation/ and s/inode/dentry/.  Maybe we can
just ignore dnotify?  :-(

Thanks.

-- 
tejun
