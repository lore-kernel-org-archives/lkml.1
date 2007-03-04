Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXCDBkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXCDBkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932646AbXCDBkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:40:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbXCDBj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:39:56 -0500
Message-ID: <45EA235B.5030201@redhat.com>
Date: Sat, 03 Mar 2007 20:39:39 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Eric St-Laurent <ericstl34@sympatico.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org> <1172967299.8493.34.camel@perkele>
In-Reply-To: <1172967299.8493.34.camel@perkele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric St-Laurent wrote:

> While I think that more user space applications should use fadvise() to
> avoid polluting the page cache with unneeded data, I still think the
> kernel should be more fair in regard to page cache management.

> Personally, I've experienced some sluggish performance after copying
> large files around. Even more when using NFS. It's difficult to file a
> bug report for "interactive feel", I don't know how to measure it. I
> just feel it's a weak aspect of the OS.

Fairness and interactiveness are very hard to quantify and
measure, which makes it hard to justify patches that improve
this behaviour.

On the other hand, patches that improve benchmark results
are easily justifyable, which makes it easy to merge those
even if it comes at the expense of fairness.

I think fairness and robustness are important, but I have
not figured out a way to justify such changes for upstream
inclusion.  Well, except perhaps by coming up with artificial
test cases, but that feels like cheating :)

> My personal opinion is that the VM seem tuned for database types
> workloads. Of course, making the page cache more fair to prevent one
> process to use most of it will most likely slowdown database type
> applications.

The database people disagree.  For one, the accessed bit
on active page gets pages gets ignored, so Linux does not
properly keep the most actively used page cache pages in
memory.

Secondly, the VM can waste quite a lot of time scanning
over the anonymous pages that it does not even want to
evict from memory.  If the VM does not plan on evicting
anonymous memory (or shared memory segments), why waste
CPU time scanning them and randomizing their LRU order?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
