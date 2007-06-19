Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbXFSXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbXFSXhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbXFSXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:37:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41494 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759522AbXFSXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:37:19 -0400
Date: Wed, 20 Jun 2007 01:37:16 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070619233716.GA5779@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 03:57:51PM -0700, Linus Torvalds wrote:
> > I'll redo the bisect with this new git.
> 
> Thanks,
> 		Linus

Well, I did a new 'git bisect' - and if you ask me - it is still broken.

It's conclusion was this time:

hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
01da41b86f6e5f9a724e20a63f093d77e37d8056 is first bad commit
commit 01da41b86f6e5f9a724e20a63f093d77e37d8056
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sat Mar 3 01:13:35 2007 +0000

    parisc: make command_line[] static

    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>

:040000 040000 eb42c17f2b8c686380fa540723d09e4b27127236 0a77f9c56f35076ae79f9f12a37769500c8f5ee9 M      arch

Here is the log:

hikaru:/usr/src/kernel/git/linux-2.6>git bisect log
git-bisect start
# bad: [188e1f81ba31af1b65a2f3611df4c670b092bbac] Linux 2.6.22-rc5
git-bisect bad 188e1f81ba31af1b65a2f3611df4c670b092bbac
# good: [99f9f3d49cbc7d944476f6fde53a77ec789ab2aa] Merge branch
# 'for-linus' of
# git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git-bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
# good: [9808901b6c63a1c850b072e624c228901a9eaf10] Blackfin serial
# driver: ignore framing and parity errors
git-bisect good 9808901b6c63a1c850b072e624c228901a9eaf10
# bad: [aba297927d1d558c7a94548135133bdf9172708a] Merge
# master.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6
git-bisect bad aba297927d1d558c7a94548135133bdf9172708a
# good: [0127d6d5d925321650e7b92364420325689a03ef] Merge branch 'master'
# of master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6
git-bisect good 0127d6d5d925321650e7b92364420325689a03ef
# bad: [25971f68d392f1816e21520e9e59648403b0bdad] [PARISC] fix section
# mismatch in ccio-dma
git-bisect bad 25971f68d392f1816e21520e9e59648403b0bdad
# bad: [7022672e4046fac4699aa5f8ff2a5213b7ec4ff9] [PARISC] spelling
# fixes: arch/parisc/
git-bisect bad 7022672e4046fac4699aa5f8ff2a5213b7ec4ff9
# bad: [fd3eef10f5a55acdefbd3f53ca7618a35cb6231f] [PARISC] Wire up
# kexec_load syscall
git-bisect bad fd3eef10f5a55acdefbd3f53ca7618a35cb6231f
# bad: [2c8307f63dd5caaf7ff8ad5118951e559a9ed5c8] parisc: sync compat
# getdents
git-bisect bad 2c8307f63dd5caaf7ff8ad5118951e559a9ed5c8
# bad: [01da41b86f6e5f9a724e20a63f093d77e37d8056] parisc: make
# command_line[] static
git-bisect bad 01da41b86f6e5f9a724e20a63f093d77e37d8056


Personally I am convinced that the real problem is with
8888985144db8f4cb7e56154b31bdf233d3550bf

    [AGPGART] intel_agp: fix device probe
    
    This patch trys to fix device probe in two cases. First we should
    correctly detect device if integrated graphics device is not enabled
    or exists, like an add-in card is plugged. Second on some type of intel
    GMCH, it might have multiple graphic chip models, like 945GME case, so
    we should be sure the detect works through the whole table.
    
    Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Jones <davej@redhat.com>


The result of this patch is that the kernel starts to print
"agpgart: Detected an Intel 965G Chipset." again with the usual
disastrous results. Now, that doesn't mean that this patch is
wrong - but it explains why the problem returns after this patch.

-- 
Carlo Wood <carlo@alinoe.com>
