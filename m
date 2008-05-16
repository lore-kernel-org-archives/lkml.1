Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbYEPUyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbYEPUyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbYEPUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:54:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbYEPUyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:54:18 -0400
Message-ID: <482DF44B.50204@redhat.com>
Date: Fri, 16 May 2008 15:53:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jamie@shareable.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 16 May 2008 14:02:46 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> A collection of patches to make ext3 & 4 use barriers by
>> default, and to call blkdev_issue_flush on fsync if they
>> are enabled.
> 
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.

I actually did a bit of research and found the old thread, honestly.  I
thought this might not be a shoo-in.  :)  Seems worth hashing out, though.

> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.

But if journali[zi]ng guarantees are thrown out the window by volatile
caches on disk, why bother with the half-solution?  Slower while you
run, worthless when you lose power?  Sounds like the worst of both
worlds.  (well, ok, experience shows that it's not worthless in practice...)

> If we were seeing a significant number of "hey, my disk got wrecked"
> reports which attributable to this then yes, perhaps we should change
> the default.  But I've never seen _any_, although I've seen claims that
> others have seen reports.

Hm, how would we know, really?  What does it look like?  It'd totally
depend on what got lost...  When do you find out?  Again depends what
you're doing, I think.  I'll admit that I don't have any good evidence
of my own.  I'll go off and do some plug-pull-testing and a benchmark or
two.

But, drive caches are only getting bigger, I assume this can't help.  I
have a hard time seeing how speed at the cost of correctness is the
right call...

> There are no happy solutions here, and I'm inclined to let this dog
> remain asleep and continue to leave it up to distributors to decide
> what their default should be.
> 
> Do we know which distros are enabling barriers by default?

SuSE does (via patch for ext3).  Red Hat & Fedora don't, and install by
default on lvm which won't pass barriers anyway.  So maybe it's
hypocritical to send this patch from redhat.com  :)

And as another "who uses barriers" datapoint, reiserfs & xfs both have
them on by default.

I suppose alternately I could send another patch to remove "remember
that ext3/4 by default offers higher data integrity guarantees than
most." from Documentation/filesystems/ext4.txt  ;)

-Eric

