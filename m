Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXF3LKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXF3LKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 07:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbXF3LKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 07:10:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbXF3LKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 07:10:35 -0400
Message-ID: <46863A23.2010001@garzik.org>
Date: Sat, 30 Jun 2007 07:10:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] fsblock
References: <20070624014528.GA17609@wotan.suse.de> <467DE00A.9080700@garzik.org> <20070630104244.GC24123@infradead.org>
In-Reply-To: <20070630104244.GC24123@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Jun 23, 2007 at 11:07:54PM -0400, Jeff Garzik wrote:
>>> - In line with the above item, filesystem block allocation is performed
>>>  before a page is dirtied. In the buffer layer, mmap writes can dirty a
>>>  page with no backing blocks which is a problem if the filesystem is
>>>  ENOSPC (patches exist for buffer.c for this).
>> This raises an eyebrow...  The handling of ENOSPC prior to mmap write is 
>> more an ABI behavior, so I don't see how this can be fixed with internal 
>> changes, yet without changing behavior currently exported to userland 
>> (and thus affecting code based on such assumptions).

> Not really, the current behaviour is a bug.  And it's not actually buffer
> layer specific - XFS now has a fix for that bug and it's generic enough
> that everyone could use it.

I'm not sure I follow.  If you require block allocation at mmap(2) time, 
rather than when a page is actually dirtied, you are denying userspace 
the ability to do sparse files with mmap.

A quick Google readily turns up people who have built upon the 
mmap-sparse-file assumption, and I don't think we want to break those 
assumptions as a "bug fix."

Where is the bug?

	Jeff


