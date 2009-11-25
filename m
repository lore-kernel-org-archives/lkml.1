Return-Path: <linux-kernel-owner+w=401wt.eu-S964942AbZKYWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbZKYWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964928AbZKYWUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:20:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44931 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924AbZKYWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:20:36 -0500
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, cmm@us.ibm.com
In-Reply-To: <20091125071804.GE17484@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost>
	 <20091118042516.GC21813@wotan.suse.de>
	 <1258683764.3840.28.camel@localhost.localdomain>
	 <20091123090630.GF5602@wotan.suse.de> <1259115377.2115.25.camel@localhost>
	 <20091125071804.GE17484@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 14:20:33 -0800
Message-ID: <1259187633.3585.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 08:18 +0100, Nick Piggin wrote:
> On Tue, Nov 24, 2009 at 06:16:17PM -0800, john stultz wrote:
> > On Mon, 2009-11-23 at 10:06 +0100, Nick Piggin wrote:
> > > BTW. Have you tested like ext4, xfs and btrfs cases?  I don't think ext3
> > > is likely to see a huge amount of scalability work, and so it will be
> > > good to give an early heads up to the more active projects...
> > 
> > Yea, I need to give those a shot. I also generated the same numbers as
> > before with ext2 (all the raw numbers are in dbench-scalability dir):
> > 
> > http://sr71.net/~jstultz/dbench-scalability/graphs/ext2-scalability.png
> > 
> > Again, its similar to ext3, in that all the -rt variants are hitting
> > some contention issues. But I was a little surprised to see
> > 2.6.32-rc7-nick below 2.6.32-rc7 there, so generated perf data there as
> > well:
> > 
> > http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.32-rc7-nick.ext2.perflog
> 
> Ext2 doesn't look too bad in the -rt profiles. The block allocator is
> only taking up a couple of % of the spinlocks. Most of the contention
> is in path lookup, probably cwd dentry contention.
> 
> The -nick case probably also is hitting d_lock contention more. Don't
> know why it shows up more on ext2. The stat path should be nothing
> filesystem specific outside the regular path lookup, until path lookup
> is done and we found the inode.
> 
> If you're using acls or something on ext2 then lock free path walk
> might fail more often.

CC'ed Ted and Mingming as they might be interested:

Got ext4 data up:
http://sr71.net/~jstultz/dbench-scalability/graphs/ext4-scalability.png

Looks pretty similar to ext2. I'm also seeing path_get contention as
well with your patch on ext4 in the perflogs:
http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.32-rc7-nick.ext4.perflog


> Anyway, I think all these problems should largely go away when path
> walk fall back is improved.

Great, let me know when you have a rough shot at it ready for testing.

thanks
-john


