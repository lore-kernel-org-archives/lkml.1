Return-Path: <linux-kernel-owner+w=401wt.eu-S935431AbYEIGJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431AbYEIGJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935021AbYEIGJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:09:39 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:44515 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764925AbYEIGJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:09:38 -0400
Message-ID: <4823EA9E.6050703@krogh.cc>
Date: Fri, 09 May 2008 08:09:34 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	<4823DFA6.9010504@krogh.cc> <20080508223635.523b8fa7.akpm@linux-foundation.org>
In-Reply-To: <20080508223635.523b8fa7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> My feeling is that the script below may reveal the bug on any "busy" 
>> volume, where busy is lots of activity in the OS-cache of the volume,
>> not on the actual drives.
> 
> By this do you mean that there has to be a lot of other activity on the
> system to reproduce it?  Stuff which is turning over memory?

Yes, something like that. (sorry for not being able to be more
concrete). The applications has "high activity" on a few files, not
spread activity throughout the volume.

> Because one possiblity is that the cached dentry got reclaimed by memory
> pressure and we have some race bug which causes us to think that the file
> doesn't exist.

What can i do to explore this theory? Can I disable caching of dentries
and see it go away? Does it fit the pattern that it is only the 
"open"-syscall that is hit (not read for example)?

> (That still shouldn't happen because the dentry should be marked
> recently-accessed, but perhaps the underlying inode gets reclaimed or
> something.  Grasping at straws here)

When I disabled the NFS-server and rand my "real-world" program on a
single processor (make -j 1). It ran through fine. It basically
gets around 20 million chunks out of differnet file and assemble the
chuncks in a few other files. This processes more or less 5 individual
sections, so make can run effectively with a concurrency of 5.

I dont know if there can be any technical reasons for not seeing it on
internal attached disks? (other than I just hadn't been able to
reproduce the same error conditions there.

Jesper
-- 
Jesper
