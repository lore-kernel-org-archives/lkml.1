Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZIRNmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZIRNmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZIRNmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:42:45 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:7350 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754239AbZIRNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:42:44 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2009 09:42:44 EDT
Message-ID: <4AB38C5A.4070506@draigBrady.com>
Date: Fri, 18 Sep 2009 14:34:18 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
References: <20090915000417.GC4507@mail.oracle.com> <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain> <20090915005417.GD4507@mail.oracle.com> <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain> <20090915040601.GE4507@mail.oracle.com> <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain> <20090915214530.GA11060@mail.oracle.com> <alpine.LFD.2.01.0909152116180.4950@localhost.localdomain> <20090916044047.GA30453@mail.oracle.com> <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain> <20090918014333.GD15620@mail.oracle.com>
In-Reply-To: <20090918014333.GD15620@mail.oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
>> Why would anybody want to hide it at all? Why even the libc hiding?
>>
>> Nobody is going to use this except for special apps. Let them see what 
>> they can do, in all its glory. 
> 
> 	I expect everyone will use this through cp(1), so that cp(1) can
> try to get server-side copy on the network filesystms.

For reference, cp(1) has a --reflink option as of
coreutils-7.5 which currently just does:

  ioctl (dest_fd, BTRFS_IOC_CLONE, src_fd);

There is a specific option in cp to do this because
a "reflink copy" was seen to have these disadvantages:

  1. one copy of data blocks so more chances of data loss
  2. disk head seeking deferred to modification process
  3. possible fragmentation on write
  4. possible ENOSPC on write

Now 2. will go away with time, and 3 & 4 may be alleviated
by the use of fallocate(), but 1. was deemed important
enough to not enable by default.

cheers,
Pádraig.

