Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZCXSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZCXSo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCXSoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:44:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41136 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZCXSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:44:20 -0400
Message-ID: <49C92963.1090505@sandeen.net>
Date: Tue, 24 Mar 2009 13:41:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324133011.GB21720@elte.hu> <20090324135112.GM5814@mit.edu> <49C9245C.9040400@rtr.ca>
In-Reply-To: <49C9245C.9040400@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Theodore Tso wrote:
>> So the question is how quickly can you *dirty* 1.6GB of memory?
> ..
> 
> MythTV:   rm /some/really/huge/video/file ; sync
>           ## disk light stays on for several minutes..
> 
> Note quite the same thing, I suppose, but it does break
> the shutdown scripts of every major Linux distribution.

It is indeed a different issue.  ext3 does a fair bit of IO on a (here
60G file) delete:

http://people.redhat.com/~esandeen/rm_test/ext3_rm.png

ext4 is much better:

http://people.redhat.com/~esandeen/rm_test/ext4_rm.png

> Simple solution for MythTV is what people already do: use xfs instead.

and yes, xfs does it very quickly:

http://people.redhat.com/~esandeen/rm_test/xfs_rm.png

-Eric
