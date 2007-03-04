Return-Path: <linux-kernel-owner+w=401wt.eu-S1751134AbXCDABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbXCDABR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 19:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXCDABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 19:01:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXCDABQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 19:01:16 -0500
Message-ID: <45EA0C3D.1010001@redhat.com>
Date: Sat, 03 Mar 2007 19:01:01 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303140744.b22699dd.akpm@linux-foundation.org>	<45E9F5DA.2070708@redhat.com> <20070303145221.2a42cc0f.akpm@linux-foundation.org>
In-Reply-To: <20070303145221.2a42cc0f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 Mar 2007 17:25:30 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
>> backup program
> 
> A suitable policy for a backup program would probably be to invalidate any
> output file(s) and to invalidate those pages of the input files which were
> not in cache when the backup program first opened those files.  That way
> the backup program will have no effect on the cache state, except for the
> race situation where someone read an uncached file while the backup program
> was reading from it too.

The use-once policy we have in the kernel should work
perfectly fine for backups.  All we need to do is
actually honor the accessed bit on active page cache
pages, instead of flushing them onto the inactive
list.

What am I overlooking?

> This can be added in an hour or two with no kernel changes (use mincore).

mincore only works for mmaped areas, we'd need an fincore
to work with file handles.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
