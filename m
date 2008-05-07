Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYEGQcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYEGQcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYEGQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:32:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:17193 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYEGQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aha83jdzFX//m4lc9hUlFsTxLpNFMAdUBRW7kbzcUOriRJ0SyvsO/R7Bz7WqHAV0GP5hbXeBw9bAKpdJpV+WOYnHm7qVJFh+7vA4vQsmnmTjUoxRraWyNeekgJWLL2v55CB852fTzZvVvsb+4hrwTJ2/vlokRhXXDH3Ob1BJpyU=
Message-ID: <91b13c310805070932s439ce4bbsfe0d658c406b55c7@mail.gmail.com>
Date: Thu, 8 May 2008 00:32:28 +0800
From: "rae l" <crquan@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: It's time to hack on dentry_stat?
Cc: "Matthew Wilcox" <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0805070910w6b304d3cye8848d5c03462aa2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
	 <20080507145116.GV19219@parisc-linux.org>
	 <2c0942db0805070808t663eafffic5e78c9d1ba8bc68@mail.gmail.com>
	 <20080507152533.GW19219@parisc-linux.org>
	 <2c0942db0805070910w6b304d3cye8848d5c03462aa2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 12:10 AM, Ray Lee <ray-lk@madrabbit.org> wrote:
>  <shrug> Well, if there's one, then obviously there isn't. I'd assumed
>  it was a per-dentry overhead.

Good. If the binary application interface must be kept,
>  $ cat /proc/sys/fs/dentry-state
>  122104  115846  45      0       0       0
and to shrink dentry_stat can only save 16 bytes, there's no need to do this,

but the Documentation/ as this should be fixed?

Documentation/filesystems/proc.txt:

dentry-state
------------

Status of  the  directory  cache.  Since  directory  entries  are  dynamically
allocated and  deallocated,  this  file indicates the current status. It holds
six values, in which the last two are not used and are always zero. The others
are listed in table 2-1.

Table 2-1: Status files of the directory cache
..............................................................................
 File       Content
 nr_dentry  Almost always zero
 nr_unused  Number of unused cache entries
 age_limit
            in seconds after the entry may be reclaimed, when memory is short
 want_pages internally
..............................................................................

the age_limit and want_pages should be marked outdated and not used anymore,

But there's still one question:
1. Is age_limit always 45? Or the binary application interface would
expect it always 45?
   Can we change dentry_stat with 6 int values all initialized with
zero? Then the docs can be
   fixed with last four values not used and are always zero.

--
Cheng
