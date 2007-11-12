Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbXKLXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbXKLXdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbXKLXdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:33:00 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:13157 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXKLXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:33:00 -0500
Date: Tue, 13 Nov 2007 00:31:03 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: Bill Lear <rael@zopyra.com>
Cc: git@vger.kernel.org, nfs@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: git 1.5.3.5 error over NFS
Message-ID: <20071112233103.GH2918@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Bill Lear <rael@zopyra.com>, git@vger.kernel.org,
	nfs@lists.sourceforge.net,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <18228.32091.865519.312011@lisa.zopyra.com> <20071109232106.GA3435@steel.home> <18232.29603.856766.275854@lisa.zopyra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18232.29603.856766.275854@lisa.zopyra.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-RZG-AUTH: z4gQVF2k5XWuW3Cculz0wOR49Q==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Lear, Mon, Nov 12, 2007 16:39:15 +0100:
> On Saturday, November 10, 2007 at 00:21:06 (+0100) Alex Riesen writes:
> >Bill Lear, Fri, Nov 09, 2007 16:31:39 +0100:
> >> I've brought this up before, but I don't recall a resolution to it.
> >> 
> >> We have an NFS-mounted filesystem, and git pull is choking on it.
> >> 
> >> % uname -a
> >> Linux uhlr.zopyra.com 2.6.9-42.0.2.ELsmp #1 SMP Wed Aug 23 13:38:27 BST 2006 x86_64 x86_64 x86_64 GNU/Linux

It is a really old kernel... Maybe you could try with some of the
recent ones?

> >> % git --version
> >> git version 1.5.3.5
> >> 
> >> % git pull
> >> remote: Generating pack...
> >> remote: Done counting 998 objects.
> >> remote: Result has 836 objects.
> >> remote: Deltifying 836 objects.
> >> remote:  100% (836/836) done
> >> Indexing 836 objects...
> >> remote: Total 836 (delta 526), reused 688 (delta 380)
> >>   100% (836/836) done
> >> Resolving 526 deltas...
> >> fatal: cannot pread pack file: No such file or directory
> >
> >Could you please strace it? With strace -ff?
> >
> >> fatal: index-pack died with error code 128
> >> fatal: Fetch failure: git://source/repo
> >> 
> >> I looked through the archives of this list and did not see a final
> >> resolution, other than a suspected bug in the OS NFS code.
> >
> >Strace, just to be on the safe side
> 
> Ok, I've done the strace -ff.  It has generated 176 strace.out.<pid>
> files.  I have placed a tarball of these files on my home server:
> 
>   http://www.zopyra.com/~rael/git/git-trace.tar.bz2
> 
> The file strace.out.25526 has, at the very end:
> 

Yes, this is the file.

I extend the part you quoted. The file is opened here:

open(".git/objects/pack_awOTNW", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
write(3, "PACK\0\0\0\2\0\0\3r", 12)     = 12
... lots of data. Counted writes: 488538...
write(3, "v\351\247V\325\362\327/\240\265\211\211\322,\261\210\301"..., 4096) = 4096
write(3, "\202\202g\232Bf\211Bf\261Bb\36X\22\4\364\365\25\22\223"..., 1114) = 1114
write(3, "M", 1)                        = 1

> write(2, "Resolving 551 deltas.\n", 22)                               = 22
> pread64(3, "", 242, 541) = 0

That's the problem.  Hmm... May I kindly suggest moving the topic to
linux-nfs (cc-ed along with lk)?

