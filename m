Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXEQLnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXEQLnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXEQLm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:42:57 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:41723 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXEQLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:42:56 -0400
Date: Thu, 17 May 2007 13:42:50 +0200
From: Johann Lombardi <johann@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-ID: <20070517114250.GA2141@chiva>
Mail-Followup-To: Johann Lombardi <johann@clusterfs.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070515143726.GC2160@chiva> <20070515101144.f7072476.akpm@linux-foundation.org> <20070515210124.GA23698@chiva> <20070515142339.4d9098f3.akpm@linux-foundation.org> <20070516153919.GC2630@chiva> <20070516091217.b9bb5797.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516091217.b9bb5797.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:12:17AM -0700, Andrew Morton wrote:
> > Basically, my problem is that afterwards, when the device no longer returns
> > any errors, the PG_error flag is never cleared and, as a result, I keep
> > getting -EIO. That's the problem I'd like to address.
> > 
> 
> hm, OK.  So, where are we up to?

Once the errors reported by the underlying device are corrected, we must
unmount/remount the filesystem if we want to use it.
In fact, since readahead ignores I/O errors, the pagecache is populated
with pages having the PG_error flag set and buffers attached.
Since PG_error is then never cleared, we keep getting EIO despite that
the underlying device works just fine.

> What is the actual real-world operational scenario here?  Would it be a
> hotplugged disk?  A transient network failure in a SAN?  IOW, is it
> something from which the kernel should automatically recover, or it is a
> situation in which manual intervention would be better?

The real-world operational scenario is a storage system reporting medium
errors which can be corrected by a manual intervention.

Johann
