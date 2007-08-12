Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbXHLFps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbXHLFps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXHLFpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:45:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:60720 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXHLFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=leVC6nKvouMlb5sr9AJQUAYMJWxfuCWKeFQYMnki7C+ABVTeOBb6ntB989xvWDzwt1SvEOf6ONRZBhAOLDoUJPa/VsydOzlKqq7W/KnRhY8uG6h8ebzZPjdbuHyq5i+jt9g5I1H/Svk97BBqo22/yW3kaU+SUZf3wlgQbaqQPcs=
Date: Sun, 12 Aug 2007 09:45:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812054526.GA7226@cvg>
References: <20070811132131.GA13775@mail.ustc.edu.cn> <20070811141714.GA7232@cvg> <20070812052915.GA6769@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812052915.GA6769@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Fengguang Wu - Sun, Aug 12, 2007 at 01:29:15PM +0800]
| On Sat, Aug 11, 2007 at 06:17:14PM +0400, Cyrill Gorcunov wrote:
| > [Fengguang Wu - Sat, Aug 11, 2007 at 09:21:31PM +0800]
| > | Andrew,
| > | 
| > | I'm not sure if this patch is the right fix for the bug.  But it do
| > | stops the oops message. The bug also happens in 2.6.23-rc1-mm2/2.6.23-rc2-mm2.
| > | I'm running debian/sid. The .config is attached.
| > | 
| > |
| > 
| > [...snip...]
| > 
| > Even if you're right you have to make the same patch for
| > mm/nommu.c but I've an anticipation the problem is growing
| > up from another point (and I'm really hoping that I'm wrong ;)
| 
| Thank you, the patch is updated to:
| ===
| 
| Fix possible NULL pointer deference on __vm_enough_memory().
| 
| Cc: Cyrill Gorcunov <gorcunov@gmail.com>
| Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
| ---
|  mm/mmap.c  |    3 ++-
|  mm/nommu.c |    3 ++-
|  2 files changed, 4 insertions(+), 2 deletions(-)
| 
| --- linux-2.6.23-rc2-mm2.orig/mm/mmap.c
| +++ linux-2.6.23-rc2-mm2/mm/mmap.c
| @@ -166,7 +166,8 @@ int __vm_enough_memory(long pages, int c
|  
|  	/* Don't let a single process grow too big:
|  	   leave 3% of the size of this process for other processes */
| -	allowed -= current->mm->total_vm / 32;
| +	if (current->mm)
| +		allowed -= current->mm->total_vm / 32;
|  
|  	/*
|  	 * cast `allowed' as a signed long because vm_committed_space
| --- linux-2.6.23-rc2-mm2.orig/mm/nommu.c
| +++ linux-2.6.23-rc2-mm2/mm/nommu.c
| @@ -1342,7 +1342,8 @@ int __vm_enough_memory(long pages, int c
|  
|  	/* Don't let a single process grow too big:
|  	   leave 3% of the size of this process for other processes */
| -	allowed -= current->mm->total_vm / 32;
| +	if (current->mm)
| +		allowed -= current->mm->total_vm / 32;
|  
|  	/*
|  	 * cast `allowed' as a signed long because vm_committed_space
| 

ok, lets wait for some mature developer comments

		Cyrill

