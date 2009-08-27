Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZH0WEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZH0WEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZH0WEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:04:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZH0WEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:04:13 -0400
Message-ID: <4A9702A2.4060700@kernel.org>
Date: Thu, 27 Aug 2009 15:03:14 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Randy Dunlap <rdunlap@xenotime.net>,
       Dave Young <hidave.darkstar@gmail.com>, webmaster@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: mm/-next release on kernel.org web page?
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com> <20090802095523.e08166e3.rdunlap@xenotime.net> <a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com> <20090802193045.c3f3195c.rdunlap@xenotime.net> <4A766F39.7090903@kernel.org> <4A95D677.2020807@kernel.org> <20090827033315.GA32648@suse.de>
In-Reply-To: <20090827033315.GA32648@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (shards.monkeyblade.net [198.137.202.13]); Thu, 27 Aug 2009 15:03:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 26, 2009 at 05:42:31PM -0700, J.H. wrote:
>> Not to reply to myself, but I've pushed out an update that should 
>> incorporate the expected trees now, this does eliminate the 2.2 and all 
>> but the last 2.4 tree (2.4.37.5), but does include all of the stable 
>> 2.6.x trees, the snapshots and linux-next.  Frontpage, finger and rss 
>> should all be showing the new information universally.  I'll probably 
>> tweak things a bit more (layout and such for the rss & html) but the 
>> kernels should now be listed as people expect.
> 
> This looks a lot better, thanks.  But note that the 2.6.28 and 2.6.29
> stable series are no longer maintained, and the current versions of them
> have known security issues, so it might not be a good idea to show that
> they are recommended for use at all.
> 
> Is there some way that we can "mark" activly maintained releases to have
> them show up on the front page in any way?  We can use the LATEST-IS
> type file in the kernel directory if you want, that would be a simple
> way to maintain this information.


The way the script works, in particular with regards to the ever 
changing realm of the 'stable' trees is this:

Wander the entire stable directory looking for git trees that have a tag 
that was last produced within 6 months (this can be shortened/lengthened 
but 6 months seemed reasonable at the time).  Pull the information for 
those kernels out and show them.  2.6.28's last tag was 3 months ago, 
2.6.29's was 7 weeks ago (almost 2 months) but things like 2.6.27 had an 
update 10 days ago.

I would be a bit concerned about using the LATEST-IS tags in the kernel 
directory, in particular there are external scripts that snag the 
LATEST-IS file to determine if a kernel needs to be pulled in, etc. 
Having multiple of those files would likely play havoc with those 
scripts as I'm sure they are doing something like:

ncftpget ftp://ftp.kernel.org/pub/linux/kernel/v2.6/LATEST-IS-*

It might also be particularly confusing to people to see multiple LATEST-IS'

Could do something based on the specific git tag for a tree, something 
like tagging the tree EOL would remove it from the list immediately, 
would have the advantage that should development be picked-back up and a 
new tag get created it would automatically show back up in the list, as 
well as it being explicit that that stable tree had stopped development.

For things like 2.6.28 & 2.6.29 that have more serious security 
vulnerabilities could setup some sort of blacklist file, or even a file 
that you could touch in the repo's directory that would blacklist it as 
well.

Like said, can always shorten the expiry period from 6 months to 3 for 
example which would more aggressively prune the list too.

Thoughts?

- John 'Warthog9' Hawley
