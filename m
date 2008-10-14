Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYJNTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYJNTTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYJNTTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:19:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbYJNTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:19:05 -0400
Date: Tue, 14 Oct 2008 12:18:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Guyot-Sionnest <dermoth@aei.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFQ Idle class slowing down everything?
Message-Id: <20081014121859.4778abcf.akpm@linux-foundation.org>
In-Reply-To: <gcm0sv$ra4$1@ger.gmane.org>
References: <gcm0sv$ra4$1@ger.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 09 Oct 2008 18:34:06 -0400 Thomas Guyot-Sionnest <dermoth@aei.ca> wrote:
> Hey,
> 
> I tried to use CFQ and ionice to help some I/O intensive tasks on a
> MySQL slave, and it turned out to makes thing much worse to the point I
> can figure out what it could be beside a bug. Tested on 2.6.20.1, but I
> could eventually upgrade if there's CFQ bugfixes I'm missing. The
> filesystem is ReiserFS.
> 
> When "idle", the slave do mostly random writes: about 15 rtps and 200
> wtps. For testing I ended up running dd to read files from disk to
> /dev/null while avoiding the system cache (had 42GB of data to read
> from, and <1GB of ram cache/buffers). Here's some sample results (I
> tried them multiple times with similar results every time). I monitored
> the iops with "sar -b 1 0"
> 
> Under deadline-iosched:
> 
> 262144000 bytes (262 MB) copied, 9.68511 seconds, 27.1 MB/s
> rtps raised over 200, wtps gets down to ~100 and then back up after the
> read operation (as MySQL catch up)
> 
> Under cfq-ipoched without ionice:
> 
> 262144000 bytes (262 MB) copied, 4.78834 seconds, 54.7 MB/s
> rtps raise over 400, wtps gets down near 0 then back up after the read.
> I can expect it as cfq does not manage the write queue, so it gives most
> bandwidth to dd
> 
> Under cfq-ipoched with ionice -c3 (mysqld was "best-effort: prio 4"):
> 13369344 bytes (13 MB) copied, 39.7619 seconds, 336 kB/s (After pressing
> CTRL-C to avoid tripping off alerting on MySQL replication)
> 
> Mysql was lagging behind at pretty much the same rate with and without
> "ionice -c3", but with the latter the copy operation was also incredibly
> slower. During the read operation rtps was around 3 and wtps was between
> 10 and 20, far beyond what that raid array is able to do with pure
> random operations.
> 
> Any ides what's going on with this scheduler?
> 
> FWIW the dd command was:
> 
> dd if=<file> of=/dev/null bs=128k skip=NNNN count=2000
> Where NNNN is a multiple of 2000 incremented by 1 on every run.
> 

Yes, 2.6.20 is dreadfully old.  If you can retest a recent kernel it would really help, thanks.
