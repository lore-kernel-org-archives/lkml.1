Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZKJVMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZKJVMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZKJVMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:12:42 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:46251 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbZKJVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:12:42 -0500
Message-ID: <4AF9D6EE.1070205@lougher.demon.co.uk>
Date: Tue, 10 Nov 2009 21:11:10 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jblunck@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, matthew@wil.cx, viro@zeniv.linux.org.uk
Subject: Re: BKL: Remove BKL from Squashfs
References: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk> <20091110121511.5adca8a9.akpm@linux-foundation.org>
In-Reply-To: <20091110121511.5adca8a9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> 
> So someone has decided to remove lots of lock_kernel()'s but chose to
> leave the squashfs_put_super() ones behind.
> 
> Why did they do that?  Your patch effectively asserts that their
> decision was incorrect.
> 


This patch was prompted by Jan Blunck's "Push down BKL to the filesystems" patch
series, where he firstly pushes the BKL down to individual filesystems
(even if they don't need it) , and then successively removes them
(on a one patch per filesystem basis) in later patches.

See http://lwn.net/Articles/359887/

His large patch pushed the BKL down to squashfs_fill_super().  He didn't send a
later patch removing them.  The BKL pushdown is unnecessary in squashfs_fill_super(),
because it isn't protecting any shared state. The BKL in squashfs_put_super() is mine.
After reviewing Jan's BKL patches I realised it was unnecessary, and it shouldn't
be there.

The patch should be reviewed in the context that it is intended for Jan's
BKL removal patch series.

Phillip
