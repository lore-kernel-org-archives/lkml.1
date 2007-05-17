Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXEQQsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXEQQsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 12:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXEQQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 12:48:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbXEQQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 12:48:43 -0400
Date: Thu, 17 May 2007 09:47:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johann Lombardi <johann@clusterfs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-Id: <20070517094730.5cdfaa64.akpm@linux-foundation.org>
In-Reply-To: <20070517114250.GA2141@chiva>
References: <20070515143726.GC2160@chiva>
	<20070515101144.f7072476.akpm@linux-foundation.org>
	<20070515210124.GA23698@chiva>
	<20070515142339.4d9098f3.akpm@linux-foundation.org>
	<20070516153919.GC2630@chiva>
	<20070516091217.b9bb5797.akpm@linux-foundation.org>
	<20070517114250.GA2141@chiva>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 13:42:50 +0200 Johann Lombardi <johann@clusterfs.com> wrote:

> > What is the actual real-world operational scenario here?  Would it be a
> > hotplugged disk?  A transient network failure in a SAN?  IOW, is it
> > something from which the kernel should automatically recover, or it is a
> > situation in which manual intervention would be better?
> 
> The real-world operational scenario is a storage system reporting medium
> errors which can be corrected by a manual intervention.

So running ioctl(BLKFLSBUF) against the device will fix things up?

Perhaps not, and we should invalidate all the file data as well. The
only ways we have of doing that are umount+mount or /proc/sys/vm/drop_caches.

I'm not sure what is the best thing to do here - there are advantages to
caching the fact that the device (or some of it) is unreadable.
