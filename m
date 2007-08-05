Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXHEGCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXHEGCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXHEGCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:02:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbXHEGCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:02:15 -0400
Date: Sat, 4 Aug 2007 23:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070804230007.30857453.akpm@linux-foundation.org>
In-Reply-To: <87wswbjejw.fsf@mid.deneb.enyo.de>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804094119.81d8e533.akpm@linux-foundation.org>
	<87wswbjejw.fsf@mid.deneb.enyo.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Aug 2007 21:16:35 +0200 Florian Weimer <fw@deneb.enyo.de> wrote:

> * Andrew Morton:
> 
> > The easy preventive is to mount with data=writeback.  Maybe that should
> > have been the default.
> 
> The documentation I could find suggests that this may lead to a
> security weakness (old data in blocks of a file that was grown just
> before the crash leaks to a different user).

yup.  This problem also exists in ext2, reiserfs (unless using
ordered-mode), JFS, others.

>  XFS overwrites that data
> with zeros upon reboot, which tends to irritate users when it happens.

yup.

> >From this point of view, data=ordered doesn't seem too bad.

If your computer is used by multiple users who don't trust each other,
sure.  That covers, what?  About 2% of machines?

I was using data=writeback for a while on my most-thrashed disk.  The
results were a bit disappointing - not much difference.  ext2 is a lot
quicker.

(I don't use anything which is fsync-happy, btw).  (I used to have a patch
which sysctl-tunably turned fsync, msync, fdatasync into "return 0" for use
on the laptop but I seem to have lost it)



