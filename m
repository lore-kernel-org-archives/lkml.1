Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZCXXER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZCXXER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZCXXEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:04:00 -0400
Received: from outbound-mail-314.bluehost.com ([67.222.54.7]:55907 "HELO
	outbound-mail-314.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753269AbZCXXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:03:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ys7E/A1v54LwZ516wZrgWdopD1DTs0OV6YCTHgWUkt89mL4cweyD8XvvmfyTR1yfp/jNBDm1IlMBVWOFv43rYhI/V/dd5s9cPBI5cBPzf/bejdO4G6ihVAKsKTPSP7VB;
Date: Tue, 24 Mar 2009 16:03:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324160353.06a4a5ed@hobbes.virtuouswap>
In-Reply-To: <20090324132032.GK5814@mit.edu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324132032.GK5814@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 09:20:32 -0400
Theodore Tso <tytso@mit.edu> wrote:
> They don't solve the problem where there is a *huge* amount of writes
> going on, though --- if something is dirtying pages at a rate far
> greater than the local disk can write it out, say, either "dd
> if=/dev/zero of=/mnt/make-lots-of-writes" or a massive distcc cluster
> driving a huge amount of data towards a single system or a wget over a
> local 100 megabit ethernet from a massive NFS server where everything
> is in cache, then you can have a major delay with the fsync().

You make it sound like this is hard to do...  I was running into this
problem *every day* until I moved to XFS recently.  I'm running a
fairly beefy desktop (VMware running a crappy Windows install w/AV junk
on it, builds, icecream and large mailboxes) and have a lot of RAM, but
it became unusable for minutes at a time, which was just totally
unacceptable, thus the switch.  Things have been better since, but are
still a little choppy.

I remember early in the 2.6.x days there was a lot of focus on making
interactive performance good, and for a long time it was.  But this I/O
problem has been around for a *long* time now... What happened?  Do not
many people run into this daily?  Do all the filesystem hackers run
with special mount options to mitigate the problem?

-- 
Jesse Barnes, Intel Open Source Technology Center
