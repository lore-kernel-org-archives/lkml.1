Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJHAXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJHAXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYJHAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:23:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:47443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbYJHAXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:23:44 -0400
Message-ID: <48EBFCD3.4050809@kernel.org>
Date: Wed, 08 Oct 2008 09:20:35 +0900
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
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>	<20081003101331.GH28946@ZenIV.linux.org.uk>	<48EB27FE.2090009@kernel.org> <m1zllgzki0.fsf@frodo.ebiederm.org>	<48EB53B8.5020309@kernel.org> <48EBEE0B.6080009@kernel.org> <m1k5cklzpc.fsf@frodo.ebiederm.org>
In-Reply-To: <m1k5cklzpc.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Oct 2008 00:22:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Hello, a bit of additions after some sleep.
> 
>> Heh... it did sound like a plan but I don't think the plan would solve
>> the problem.  filldir can't be put in rcu read critical section.  :-p
> 
> There is srcu and there is the trick of grabbing the reference count
> on the current sysfs_dirent over the filldir and dropping the rcu
> lock (which works for proc).

Hmmm... I'm probably missing something (and being lazy) but how does it
guarantee the validity of the next pointer after dropping the rcu lock?

> To cut down on lock overhead from user space accesses that works.
> 
>>>> The revalidate on access model doesn't appear to have a way to track
>>>> remote renames.  Something sysfs supports.
>>> Yeap, IIRC, one of the reasons why sysfs wasn't converted over to
>>> sysfs was because sysfs guarantees inode doesn't change over rename or
>>> move so that notifications keep working over renames.
>> s/over to sysfs/over to revalidation/ and s/inode/dentry/.  Maybe we can
>> just ignore dnotify?  :-(
> 
> Well there are more cases than dnotify, there is the renaming of directories
> in sysfs, although rare that I think get awkward if we use revalidation.
> 
> I'm still not certain how we can get the lock ordering so it doesn't
> cause us problems.  I will look at revalidation and what the other
> distributed filesystems are doing and see if that might work.  If it
> doesn't we need refactor the VFS locking.

Yeah, if we can make sysfs behave like other distributed filesystems, it
would be great.  :-)

Thanks.

-- 
tejun
